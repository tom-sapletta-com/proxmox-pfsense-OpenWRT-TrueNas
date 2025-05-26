#!/bin/bash
# check_prerequisites.sh - Verify system requirements for Proxmox, pfSense, OpenWRT, and TrueNAS
# Author: Tom Sapletta
# Website: https://github.com/tom-sapletta-com

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then 
    echo -e "${YELLOW}This script should be run as root${NC}" >&2
    exit 1
fi

echo -e "${GREEN}=== System Requirements Check ===${NC}"

# Check CPU virtualization support
if egrep -c '(vmx|svm)' /proc/cpuinfo > /dev/null; then
    echo -e "${GREEN}✓ CPU virtualization support: Enabled${NC}"
else
    echo -e "${RED}✗ CPU virtualization support: Not found${NC}"
    echo "  - Make sure virtualization is enabled in BIOS"
    exit 1
fi

# Check total RAM (minimum 8GB recommended)
TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
if [ "$TOTAL_RAM" -lt 8 ]; then
    echo -e "${YELLOW}⚠  Low RAM: ${TOTAL_RAM}GB detected (8GB+ recommended)${NC}"
else
    echo -e "${GREEN}✓ System RAM: ${TOTAL_RAM}GB${NC}"
fi

# Check available disk space (minimum 100GB recommended)
DISK_SPACE=$(df -BG --output=avail / | tail -n 1 | tr -d ' ' | tr -d 'G')
if [ "$DISK_SPACE" -lt 100 ]; then
    echo -e "${YELLOW}⚠  Low disk space: ${DISK_SPACE}GB available (100GB+ recommended)${NC}"
else
    echo -e "${GREEN}✓ Disk space: ${DISK_SPACE}GB available${NC}"
fi

# Check Proxmox installation
if [ -f "/etc/pve/version" ]; then
    PROXMOX_VER=$(pveversion | cut -d'/' -f1)
    echo -e "${GREEN}✓ Proxmox VE installed: ${PROXMOX_VER}${NC}"
else
    echo -e "${RED}✗ Proxmox VE is not installed${NC}"
    echo "  - Install Proxmox VE first: https://pve.proxmox.com/wiki/Installation"
    exit 1
fi

echo -e "\n${GREEN}=== Network Configuration Check ===${NC}"

# Check network interfaces
echo -e "${GREEN}Network Interfaces:${NC}"
ip -br a | grep -v '^lo\|^veth\|^docker\|^br-' | awk '{print "  " $1 " (" $3 ")"}'

# Check internet connectivity
if ping -c 1 google.com &> /dev/null; then
    echo -e "${GREEN}✓ Internet connection: OK${NC}"
else
    echo -e "${YELLOW}⚠  No internet connection detected${NC}"
fi

echo -e "\n${GREEN}=== System Check Complete ===${NC}"
echo "For detailed information about system requirements, visit:"
echo "- Proxmox: https://pve.proxmox.com/wiki/Installation#system_requirements"
echo "- pfSense: https://docs.netgate.com/pfsense/en/latest/install/install.html"
echo "- OpenWRT: https://openwrt.org/docs/guide-user/start"
echo "- TrueNAS: https://www.truenas.com/docs/hardware/"

exit 0
