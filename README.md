# proxmox-pfsense-OpenWRT-TrueNas
How to install pfsense, OpenWRT, TrueNAS on proxmox


+ [How to Install pfSense on Proxmox in 2023 - WunderTech](https://www.wundertech.net/how-to-install-pfsense-on-proxmox/)
+ [Run an OpenWRT VM on Proxmox VE](https://i12bretro.github.io/tutorials/0405.html)


## download image

1. Download the latest AMD64 DVD Image (ISO) installer from the pfSense website.
+ [Download pfSense Community Edition](https://www.pfsense.org/download/)


2. Upload the ISO that was just downloaded to the Proxmox server.
3. Select Create VM in the top right corner.
+ [How to Install pfSense on Proxmox in 2023 - WunderTech](https://www.wundertech.net/how-to-install-pfsense-on-proxmox/)

Before we look at how to install pfSense on Proxmox, ensure that you have a NIC installed in your Proxmox server as we’ll have to use this to pass it through to our pfSense virtual machine.


4. Give the VM a name, then check off start at boot. Select next to proceed.
5. Select the pfSense ISO image and then select next.
6. In the network section, select no network device, then select next.
7. 

## Proxmox 

add the new network card to proxmox usage
and use embedded cards to pfsense directly from PCI

### TODO:

+ change the physical network device in vmbr0 to the external USB card

![image](https://github.com/tom-sapletta-com/proxmox-pfsense-OpenWRT-TrueNas/assets/5669657/c10c2d7b-3614-4bef-b09a-2b128bdcf104)



## Tutorials:

[How to Virtualize Your Home Router / Firewall Using pfSense - YouTube](https://www.youtube.com/watch?v=hdoBQNI_Ab8)
