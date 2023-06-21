# proxmox-pfsense-OpenWRT-TrueNas
How to install pfsense, OpenWRT, TrueNAS on proxmox


+ [How to Install pfSense on Proxmox in 2023 - WunderTech](https://www.wundertech.net/how-to-install-pfsense-on-proxmox/)
+ [Run an OpenWRT VM on Proxmox VE](https://i12bretro.github.io/tutorials/0405.html)
+ [Proxmox: How to Delete VM, VM Disks & VM Snapshots - phoenixNAP KB](https://phoenixnap.com/kb/proxmox-delete-vm)
+ [Network Configuration - Proxmox VE](https://pve.proxmox.com/wiki/Network_Configuration)
+ [How to Configure a pfSense Network Bridge on a Dedicated Server – Articles](https://support.us.ovhcloud.com/hc/en-us/articles/6270170579347-How-to-Configure-a-pfSense-Network-Bridge-on-a-Dedicated-Server)
  
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


## TEST COnfig

+ [Troubleshooting — Troubleshooting Network Connectivity | pfSense Documentation](https://docs.netgate.com/pfsense/en/latest/troubleshooting/connectivity.html)



## Tutorials:

+ [How to Virtualize Your Home Router / Firewall Using pfSense - YouTube](https://www.youtube.com/watch?v=hdoBQNI_Ab8)
