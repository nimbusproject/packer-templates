This Packer template is used to generate a Xen image of Debian Lenny
amd64 (5.0.10).

It was created from veewee template Debian-5.0.10-amd64-netboot and
modified as follows.

http/preseed.cfg was changed to:

* use regular partitioning instead of lvm
* partition the virtual disk with a single ext3 root partition
* ignore the absence of swap partition 
* create a root user and skip normal user account creation

template.json had the vmware builder removed and was changed to:

* remove all veewee default scripts (ruby, chef, etc.)
* use root:vagrant to connect to the virtual machine
* remove VirtualBox files uploaded by Packer
* remove 70-persistent-net.rules to allow a change of MAC address
* install curl, lsb-release, sudo, and wget
* install dhcpcd and a customized configuration
* install a custom fstab that uses rootfs instead of a hardcoded partition name
* remove the root password so that only SSH keys can be used

Finally, the scripts ../common/vmdk-to-raw.sh and
../common/vmdk-to-xen-raw.sh are used to convert the packer-disk1.vmdk
VMDK file to KVM and Xen images, respectively. They do so by:

* converting the packer-disk1.vmdk file from VMDK to raw format
* only for vmdk-to-xen-raw.sh: removing the MBR from it, resulting in a file containing only the root partition
* compressing the resulting image using gzip

qemu-img is required to run these scripts.
