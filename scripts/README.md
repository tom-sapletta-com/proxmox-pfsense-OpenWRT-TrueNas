# Proxmox Helper Scripts

This directory contains helper scripts for managing Proxmox, pfSense, OpenWRT, and TrueNAS environments. These scripts are designed to automate common tasks and make system administration easier.

## Available Scripts

### 1. `check_prerequisites.sh`

Verifies system requirements for running Proxmox, pfSense, OpenWRT, and TrueNAS.

**Usage:**
```bash
sudo ./check_prerequisites.sh
```

**Checks:**
- CPU virtualization support
- System RAM
- Available disk space
- Proxmox installation
- Network configuration
- Internet connectivity

---

### 2. `deploy_pfsense_vm.sh`

Deploys a pfSense virtual machine on Proxmox.

**Usage:**
```bash
sudo ./deploy_pfsense_vm.sh --id 100 --name "pfsense-router" --memory 2048 --cores 2 --storage local-lvm --iso /path/to/pfSense-*.iso
```

**Options:**
- `--id`: VM ID (default: 100)
- `--name`: VM name (default: pfsense)
- `--memory`: Memory in MB (default: 2048)
- `--cores`: Number of CPU cores (default: 2)
- `--storage`: Storage name (default: local-lvm)
- `--iso`: Path to pfSense ISO file (required)
- `--bridge`: Network bridge (default: vmbr0)

---

### 3. `backup_vms.sh`

Backs up Proxmox VMs and containers to a specified directory.

**Usage:**
```bash
sudo ./backup_vms.sh --dir /mnt/backup/proxmox --compression lzo --max 7 --exclude 100,101
```

**Options:**
- `--dir`: Backup directory (default: /mnt/backup/proxmox)
- `--compression`: Compression type: lzo, gzip, or zstd (default: lzo)
- `--max`: Maximum number of backups to keep (default: 7)
- `--exclude`: Comma-separated list of VM/CT IDs to exclude

## Requirements

- Proxmox VE installed
- Root access
- Internet connectivity (for some checks)

## Author

**Tom Sapletta**  
- GitHub: [tom-sapletta-com](https://github.com/tom-sapletta-com)  
- LinkedIn: [Tom Sapletta](https://linkedin.com/in/tom-sapletta-com)  
- ORCID: 0009-0000-6327-2810  
- Blogs: [EN](https://tom.sapletta.com) | [DE](https://tom.sapletta.de) | [PL](https://tom.sapletta.pl)

## License

This project is open-source and available under the MIT License.
