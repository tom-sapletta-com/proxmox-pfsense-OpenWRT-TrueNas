# Proxmox + pfSense + OpenWRT + TrueNAS

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/tom-sapletta-com/proxmox-pfsense-OpenWRT-TrueNas/graphs/commit-activity)

A comprehensive guide and automation toolkit for setting up and managing a powerful virtualized home or small business network environment using Proxmox, pfSense, OpenWRT, and TrueNAS.

## 🚀 Quick Start

### Prerequisites
- Proxmox VE installed on your server
- Basic understanding of networking concepts
- Minimum 8GB RAM (16GB+ recommended)
- 100GB+ free disk space

### Quick Commands

```bash
# Check system requirements
make check

# Install required dependencies
make setup

# Deploy pfSense VM
make deploy-pfsense

# Backup your VMs
make backup
```

## 📋 Table of Contents

- [Features](#-features)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#-usage)
  - [Deploying VMs](#deploying-vms)
  - [Backup & Recovery](#backup--recovery)
  - [Maintenance](#maintenance)
- [Documentation](#-documentation)
- [Contributing](#-contributing)
- [License](#-license)
- [About the Author](#-about-the-author)

## ✨ Features

- **Automated Deployment**: Scripts to deploy and configure virtual machines
- **System Validation**: Pre-flight checks for system requirements
- **Backup Solutions**: Automated backup of VMs and containers
- **Modular Design**: Easy to extend and customize
- **Documentation**: Comprehensive guides and references

## 📁 Project Structure

```
.
├── scripts/                  # Automation scripts
│   ├── check_prerequisites.sh  # System requirements check
│   ├── deploy_pfsense_vm.sh    # pfSense VM deployment
│   ├── deploy_openwrt_vm.sh    # OpenWRT VM deployment (coming soon)
│   ├── deploy_truenas_vm.sh    # TrueNAS VM deployment (coming soon)
│   └── backup_vms.sh          # Backup solution for VMs
├── docs/                     # Additional documentation
│   ├── networking/           # Network configuration guides
│   ├── security/             # Security best practices
│   └── troubleshooting/      # Common issues and solutions
├── .gitignore               # Git ignore file
├── LICENSE                  # MIT License
├── Makefile                 # Project automation
└── README.md               # This file
```

## 🚀 Getting Started

### Prerequisites

- Proxmox VE 7.0 or later
- CPU with hardware virtualization support (Intel VT-x/AMD-V)
- Minimum 8GB RAM (16GB+ recommended)
- 100GB+ free disk space
- Network connectivity

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/tom-sapletta-com/proxmox-pfsense-OpenWRT-TrueNas.git
   cd proxmox-pfsense-OpenWRT-TrueNas
   ```

2. Install dependencies:
   ```bash
   make setup
   ```

3. Make scripts executable:
   ```bash
   make install
   ```

## 🛠️ Usage

### Deploying VMs

#### pfSense Firewall/Router
```bash
make deploy-pfsense
```

Or manually:
```bash
sudo ./scripts/deploy_pfsense_vm.sh \
  --id 100 \
  --name "pfsense" \
  --memory 2048 \
  --cores 2 \
  --storage local-lvm \
  --iso /path/to/pfSense-*.iso
```

#### OpenWRT (Coming Soon)
```bash
make deploy-openwrt
```

#### TrueNAS (Coming Soon)
```bash
make deploy-truenas
```

### Backup & Recovery

Create a backup of all VMs and containers:
```bash
make backup
```

Or customize the backup:
```bash
sudo ./scripts/backup_vms.sh \
  --dir /mnt/backup/proxmox \
  --compression zstd \
  --max 7 \
  --exclude 101,102
```

### Maintenance

Check system requirements:
```bash
make check
```

Clean up temporary files:
```bash
make clean
```

## 📚 Documentation

For detailed documentation, please refer to the following resources:

- [Proxmox VE Documentation](https://pve.proxmox.com/pve-docs/)
- [pfSense Documentation](https://docs.netgate.com/pfsense/en/latest/)
- [OpenWRT Documentation](https://openwrt.org/docs/start)
- [TrueNAS Documentation](https://www.truenas.com/docs/)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 About the Author

**Tom Sapletta** is a technology enthusiast and software developer with a passion for:

- **Automated code generation (TextToSoftware)**
- **Hypermodularization**
- **Edge computing & distributed systems**
- **MBSE, Component-Based Development, Digital Twins**

### Connect with me:

- 💼 [LinkedIn](https://linkedin.com/in/tom-sapletta-com)
- 🌐 [GitHub](https://github.com/tom-sapletta-com)
- 📝 [Blogs](https://tom.sapletta.com) | [DE](https://tom.sapletta.de) | [PL](https://tom.sapletta.pl)
- 📫 ORCID: 0009-0000-6327-2810


+ [How to Install pfSense on Proxmox in 2023 - WunderTech](https://www.wundertech.net/how-to-install-pfsense-on-proxmox/)
+ [Run an OpenWRT VM on Proxmox VE](https://i12bretro.github.io/tutorials/0405.html)
+ [Proxmox: How to Delete VM, VM Disks & VM Snapshots - phoenixNAP KB](https://phoenixnap.com/kb/proxmox-delete-vm)
+ [Network Configuration - Proxmox VE](https://pve.proxmox.com/wiki/Network_Configuration)
+ [How to Configure a pfSense Network Bridge on a Dedicated Server – Articles](https://support.us.ovhcloud.com/hc/en-us/articles/6270170579347-How-to-Configure-a-pfSense-Network-Bridge-on-a-Dedicated-Server)
+ [pfSense VLANs on Proxmox - Linux Included](https://linuxincluded.com/pfsense-vlans-on-proxmox/)

## download image

1. Download the latest AMD64 DVD Image (ISO) installer from the pfSense website.
+ [Download pfSense Community Edition](https://www.pfsense.org/download/)


2. Upload the ISO that was just downloaded to the Proxmox server.
3. Select Create VM in the top right corner.
+ [How to Install pfSense on Proxmox in 2023 - WunderTech](https://www.wundertech.net/how-to-install-pfsense-on-proxmox/)

Before we look at how to install pfSense on Proxmox, ensure that you have a NIC installed in your Proxmox server as we’ll have to use this to pass it through to our pfSense virtual machine.
+ [How to Pass-through PCIe NICs with Proxmox VE on Intel and AMD](https://www.servethehome.com/how-to-pass-through-pcie-nics-with-proxmox-ve-on-intel-and-amd/)

4. Give the VM a name, then check off start at boot. Select next to proceed.
5. Select the pfSense ISO image and then select next.
6. In the network section, select no network device, then select next.


## Proxmox 

+ [pfSense® software Configuration Recipes — Virtualizing with Proxmox® VE | pfSense Documentation](https://docs.netgate.com/pfsense/en/latest/recipes/virtualize-proxmox-ve.html)


## Virtualisation

```bash
qm monitor <vmid>       connect to vm control monitor
qm start <vmid>         start vm
qm reboot <vmid>        reboot vm (shutdown, start)
qm shutdown <vmid>      gracefully stop vm (send poweroff)
qm stop <vmid>          kill vm (immediate stop)
qm reset <vmid>         reset vm (stop, start)
qm suspend <vmid>       suspend vm
qm resume <vmid>        resume vm
qm destroy <vmid>       destroy vm (delete all files)

qm cdrom <vmid> [<device>] <path>  set cdrom path. <device is ide2 by default>
qm cdrom <vmid> [<device>] eject   eject cdrom

qm unlink <vmid> <file>  delete unused disk images
qm vncproxy <vmid> <ticket>  open vnc proxy
qm list                 list all virtual machines
```


### BIOS

When creating the VM:
+ Set Machine to q35
+ Set BIOS to OVMF (UEFI)
On the first boot, go into the boot settings and disable secure boot:

+ Hit Esc while the boot splash screen is visible
+ Select Device Manager
+ Select Secure Boot Configuration
+ Uncheck Attempt Secure Boot
+ Press F10 to save
+ Press Esc to exit
  
add the new network card to proxmox usage
and use embedded cards to pfsense directly from PCI


+ change the physical network device in vmbr0 to the external USB card

![image](https://github.com/tom-sapletta-com/proxmox-pfsense-OpenWRT-TrueNas/assets/5669657/c10c2d7b-3614-4bef-b09a-2b128bdcf104)


+ Add PCI NET Devices Before start pfsense

![image](https://github.com/tom-sapletta-com/proxmox-pfsense-OpenWRT-TrueNas/assets/5669657/ece5a7d9-c83b-489b-9790-ed28221386f6)


+ All functions
  
![image](https://github.com/tom-sapletta-com/proxmox-pfsense-OpenWRT-TrueNas/assets/5669657/ad156e0b-9903-4030-ac1e-df37bbaa9a67)



## Proxmox virtualized Net

[pfSense® software Configuration Recipes — Virtualizing with Proxmox® VE - pfSense Documentation](https://docs.netgate.com/pfsense/en/latest/recipes/virtualize-proxmox-ve.html)


# pfsense Installation

### CONFIG

> After the virtual machine reboots, the console will stop at an interfaces assignment prompt.
> 
> - Type `n` and press `Enter` to skip VLAN configuration
>     
> - Enter `vtnet0` for WAN
>     
> - Enter `vtnet1` for LAN
>     
> - Press `Enter` if prompted for additional interfaces
>     
> - Type `y` and press `Enter` to complete the interface assignment

## Network

[How to reload /etc/network/interfaces in Ubuntu or Debian](https://www.xmodulo.com/how-to-reload-etc-network-interfaces-in-ubuntu-debian.html)

> In Ubuntu or Debian desktop, Network Manager is the default network configuration tool, whereas Ubuntu server by default uses `/etc/network/interfaces` to configure network interfaces. Of course, even on desktop, you can [disable Network Manager](https://www.xmodulo.com/disable-network-manager-linux.html), and use `/etc/network/interfaces` instead to configure your networking.
> 
> For those of you who use `/etc/network/interfaces` to configure network interfaces, if you modify `/etc/network/interfaces`, you need to reload it so that the new configuration can take effect.
> 
 (adsbygoogle = window.adsbygoogle || \[\]).push({});
 
Here is how you can reload `/etc/network/interfaces`.
 
```
sudo service networking restart
```

**Note:** If Network Manager is installed and enabled on your system, you must not use `/etc/network/interfaces` to configure networking, and any change made in `/etc/network/interfaces` will be ignored by Network Manager. You need to use Network Manager to configure your network interfaces. In that case, after network settings are modified, you can restart Network manager as follows.

```
sudo service network-manager restart
```

## Additional Resources

### Proxmox
- [Official Proxmox Documentation](https://pve.proxmox.com/pve-docs/)
- [Proxmox VE Administration Guide](https://pve.proxmox.com/pve-docs/pve-admin-guide.html)
- [Proxmox Network Configuration](https://pve.proxmox.com/wiki/Network_Configuration)
- [Proxmox Backup & Restore](https://pve.proxmox.com/wiki/Backup_and_Restore)
- [Proxmox API Documentation](https://pve.proxmox.com/pve-docs/api-viewer/)

### pfSense
- [Official pfSense Documentation](https://docs.netgate.com/pfsense/en/latest/)
- [pfSense Hardware Requirements](https://docs.netgate.com/pfsense/en/latest/hardware/index.html)
- [pfSense Firewall Rules](https://docs.netgate.com/pfsense/en/latest/firewall/rule-methodology.html)
- [pfSense VPN Setup](https://docs.netgate.com/pfsense/en/latest/vpn/index.html)
- [pfSense Packages](https://docs.netgate.com/pfsense/en/latest/packages/index.html)

### OpenWRT
- [OpenWRT Documentation](https://openwrt.org/docs/start)
- [OpenWRT Hardware Table](https://openwrt.org/toh/start)
- [OpenWRT on Proxmox](https://openwrt.org/docs/guide-user/virtualization/proxmox)
- [OpenWRT Network Configuration](https://openwrt.org/docs/guide-user/base-system/basic-networking)

### TrueNAS
- [TrueNAS Documentation](https://www.truenas.com/docs/)
- [TrueNAS Hardware Guide](https://www.truenas.com/docs/hardware/)
- [TrueNAS on Proxmox](https://www.truenas.com/community/threads/true-nas-on-proxmox.102655/)
- [TrueNAS Storage Pools](https://www.truenas.com/docs/core/storage/pools/)

### Network Configuration
- [VLAN Configuration Guide](https://www.cisco.com/c/en/us/td/docs/switches/lan/catalyst4000/8-2glx/configuration/guide/vlans.html)
- [Subnet Cheat Sheet](https://www.aelius.com/njh/subnet_sheet.html)
- [OpenVPN Setup](https://openvpn.net/vpn-server-resources/)
- [WireGuard Setup](https://www.wireguard.com/)

### Troubleshooting
- [Wireshark](https://www.wireshark.org/) - Network protocol analyzer
- [iperf3](https://iperf.fr/) - Network performance measurement tool
- [MTR](https://www.bitwizard.nl/mtr/) - Network diagnostic tool
- [Netdata](https://www.netdata.cloud/) - Real-time performance monitoring

### Security
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)
- [NIST Security Guidelines](https://www.nist.gov/cyberframework)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)

### Community & Support
- [Reddit - r/homelab](https://www.reddit.com/r/homelab/)
- [Reddit - r/PFSENSE](https://www.reddit.com/r/PFSENSE/)
- [Reddit - r/Proxmox](https://www.reddit.com/r/Proxmox/)
- [Reddit - r/OpenWRT](https://www.reddit.com/r/openwrt/)
- [Reddit - r/truenas](https://www.reddit.com/r/truenas/)

### YouTube Channels
- [Lawrence Systems](https://www.youtube.com/c/LawrenceSystems)
- [Crosstalk Solutions](https://www.youtube.com/c/CrosstalkSolutions)
- [Techno Tim](https://www.youtube.com/c/TechnoTimLive)
- [NetworkChuck](https://www.youtube.com/c/NetworkChuck)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Thanks to all the open-source communities for their amazing work
- Special thanks to the Proxmox, pfSense, OpenWRT, and TrueNAS teams
- Inspired by the homelab community


## [Subnet Cheat Sheet – 24 Subnet Mask, 30, 26, 27, 29, and other IP Address CIDR Network References](https://www.freecodecamp.org/news/subnet-cheat-sheet-24-subnet-mask-30-26-27-29-and-other-ip-address-cidr-network-references/)

![image](https://github.com/tom-sapletta-com/proxmox-pfsense-OpenWRT-TrueNas/assets/5669657/ae359060-9d05-46ee-bc87-3751a9d4d2fc)


## TEST COnfig

+ [Troubleshooting — Troubleshooting Network Connectivity | pfSense Documentation](https://docs.netgate.com/pfsense/en/latest/troubleshooting/connectivity.html)



## Tutorials:

+ [How to Virtualize Your Home Router / Firewall Using pfSense - YouTube](https://www.youtube.com/watch?v=hdoBQNI_Ab8)
+ [Building a budget 10gbe router/firewall with pfSense from scratch](https://drakeor.com/2021/04/14/setting-up-pfsense-as-a-router/)
