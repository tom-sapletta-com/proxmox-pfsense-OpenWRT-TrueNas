#!/bin/bash
# deploy_pfsense_vm.sh - Deploy a pfSense VM on Proxmox
# Author: Tom Sapletta
# Website: https://github.com/tom-sapletta-com

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Default values
VM_ID=100
VM_NAME="pfsense"
MEMORY=2048
CORES=2
STORAGE="local-lvm"
PF_SENSE_ISO=""
BRIDGE="vmbr0"

# Display usage information
usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  --id ID               VM ID (default: $VM_ID)"
    echo "  --name NAME          VM name (default: $VM_NAME)"
    echo "  --memory MB          Memory in MB (default: $MEMORY)"
    echo "  --cores N            Number of CPU cores (default: $CORES)"
    echo "  --storage STORAGE     Storage name (default: $STORAGE)"
    echo "  --iso PATH           Path to pfSense ISO"
    echo "  --bridge BRIDGE      Network bridge (default: $BRIDGE)"
    echo "  --help               Show this help"
    exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --id)
            VM_ID="$2"
            shift 2
            ;;
        --name)
            VM_NAME="$2"
            shift 2
            ;;
        --memory)
            MEMORY="$2"
            shift 2
            ;;
        --cores)
            CORES="$2"
            shift 2
            ;;
        --storage)
            STORAGE="$2"
            shift 2
            ;;
        --iso)
            PF_SENSE_ISO="$2"
            shift 2
            ;;
        --bridge)
            BRIDGE="$2"
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

# Check if ISO is provided
if [ -z "$PF_SENSE_ISO" ]; then
    echo -e "${YELLOW}Please provide the path to pfSense ISO using --iso parameter${NC}"
    echo -e "Download pfSense from: ${GREEN}https://www.pfsense.org/download/${NC}"
    exit 1
fi

# Check if ISO file exists
if [ ! -f "$PF_SENSE_ISO" ]; then
    echo -e "${RED}ISO file not found: $PF_SENSE_ISO${NC}" >&2
    exit 1
fi

echo -e "${GREEN}=== Creating pfSense VM (ID: $VM_ID) ===${NC}"

# Create VM
qm create $VM_ID --name "$VM_NAME" --memory $MEMORY --cores $CORES --net0 virtio,bridge=$BRIDGE

# Import disk
qm importdisk $VM_ID "$PF_SENSE_ISO" $STORAGE

# Configure VM
qm set $VM_ID \
    --scsihw virtio-scsi-pci \
    --scsi0 $STORAGE:vm-$VM_ID-disk-0,media=cdrom \
    --boot c --bootdisk scsi0 \
    --ostype l26 \
    --ide2 $STORAGE:cloudinit \
    --sockets 1 \
    --onboot 1 \
    --agent enabled=1

# Add network interfaces
qm set $VM_ID --net0 virtio,bridge=$BRIDGE

# Add serial console
qm set $VM_ID --serial0 socket --vga serial0

echo -e "${GREEN}✓ pfSense VM created successfully!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Start the VM: qm start $VM_ID"
echo "2. Connect to the console: qm terminal $VM_ID"
echo "3. Follow the on-screen instructions to complete the pfSense installation"
echo "4. After installation, don't forget to remove the ISO from the VM configuration"

exit 0
