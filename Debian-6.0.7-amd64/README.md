This Packer template is used to generate a Xen image of Debian Squeeze
amd64 (6.0.7).

The process is a bit convoluted because our cloud platform boots virtual
machines with a 2.6.18 kernel from RHEL 5 which is not compatible with
recent versions of udev, including the one in Squeeze (see
https://bugs.launchpad.net/ubuntu/+source/udev/+bug/397187).
Thus, the template was created from veewee template
Debian-5.0.10-amd64-netboot and modified as follows.

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

Those steps are common with the Debian-5.0.10-amd64 image. Additionally,
we hold udev to the Lenny package, update sources.list to use the
Squeeze repository, and run apt-get dist-upgrade with the options
required for a fully non interactive upgrade.

Finally, the scripts ../common/vmdk-to-raw.sh and
../common/vmdk-to-xen-raw.sh are used to convert the packer-disk1.vmdk
VMDK file to KVM and Xen images, respectively. They do so by:

* converting the packer-disk1.vmdk file from VMDK to raw format
* only for vmdk-to-xen-raw.sh: removing the MBR from it, resulting in a file containing only the root partition
* compressing the resulting image using gzip

qemu-img is required to run this script.
