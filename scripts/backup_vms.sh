#!/bin/bash
# backup_vms.sh - Backup Proxmox VMs and containers
# Author: Tom Sapletta
# Website: https://github.com/tom-sapletta-com

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Default values
BACKUP_DIR="/mnt/backup/proxmox"
COMPRESSION="lzo"
MAX_BACKUPS=7
EXCLUDE_IDS=()

# Display usage information
usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  --dir DIR          Backup directory (default: $BACKUP_DIR)"
    echo "  --compression X   Compression type (lzo, gzip, zstd) (default: $COMPRESSION)"
    echo "  --max N           Maximum number of backups to keep (default: $MAX_BACKUPS)"
    echo "  --exclude ID1,ID2  Comma-separated list of VM/CT IDs to exclude"
    echo "  --help            Show this help"
    exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dir)
            BACKUP_DIR="$2"
            shift 2
            ;;
        --compression)
            COMPRESSION="$2"
            shift 2
            ;;
        --max)
            MAX_BACKUPS="$2"
            shift 2
            ;;
        --exclude)
            IFS=',' read -r -a EXCLUDE_IDS <<< "$2"
            shift 2
            ;;
        --help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then 
    echo -e "${RED}This script must be run as root${NC}" >&2
    exit 1
fi

# Check if Proxmox is installed
if [ ! -f "/etc/pve/version" ]; then
    echo -e "${RED}This script must be run on a Proxmox VE host${NC}" >&2
    exit 1
fi

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_PATH="$BACKUP_DIR/backup_$TIMESTAMP"
mkdir -p "$BACKUP_PATH"

# Function to check if VM/CT should be excluded
should_exclude() {
    local vm_id=$1
    for exclude_id in "${EXCLUDE_IDS[@]}"; do
        if [ "$vm_id" == "$exclude_id" ]; then
            return 0
        fi
    done
    return 1
}

echo -e "${GREEN}=== Starting Proxmox Backup ===${NC}"
echo -e "Backup directory: ${YELLOW}$BACKUP_PATH${NC}"
echo -e "Compression: ${YELLOW}$COMPRESSION${NC}"

# Backup VMs
for vm in $(qm list | awk 'NR>1 {print $1}'); do
    if ! should_exclude "$vm"; then
        VM_NAME=$(qm config "$vm" | grep '^name:' | awk '{print $2}' || echo "vm$vm")
        echo -e "${GREEN}Backing up VM $vm ($VM_NAME)...${NC}"
        qm stop "$vm" || true
        qm backup "$vm" "$BACKUP_PATH/vm${vm}_${VM_NAME}.tar" --compress "$COMPRESSION"
        qm start "$vm" || true
    else
        echo -e "${YELLOW}Skipping excluded VM $vm${NC}"
    fi
done

# Backup containers
for ct in $(pct list | awk 'NR>1 {print $1}'); do
    if ! should_exclude "$ct"; then
        CT_NAME=$(pct config "$ct" | grep '^hostname:' | awk '{print $2}' || echo "ct$ct")
        echo -e "${GREEN}Backing up container $ct ($CT_NAME)...${NC}"
        pct stop "$ct" || true
        pct backup "$ct" "$BACKUP_PATH/ct${ct}_${CT_NAME}.tar" --compress "$COMPRESSION"
        pct start "$ct" || true
    else
        echo -e "${YELLOW}Skipping excluded container $ct${NC}"
    fi
done

# Clean up old backups if needed
if [ "$MAX_BACKUPS" -gt 0 ]; then
    echo -e "${GREEN}Cleaning up old backups (keeping last $MAX_BACKUPS)...${NC}"
    (cd "$BACKUP_DIR" && ls -1tr | grep '^backup_' | head -n -"$MAX_BACKUPS" | xargs -r rm -r)
fi

echo -e "${GREEN}✓ Backup completed successfully!${NC}"
echo -e "Backup location: ${YELLOW}$BACKUP_PATH${NC}"

# Display disk usage
echo -e "${GREEN}Disk usage:${NC}"
df -h "$BACKUP_DIR"

exit 0
