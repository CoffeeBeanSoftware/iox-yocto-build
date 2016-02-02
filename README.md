# A Yocto Build for IOx

This project is a tutorial and instructions on how to build a x86_64 [Yocto](http://www.yoctoproject.org) image, potentially suitable for use with [Cisco's IOx platform.](https://communities.cisco.com/community/developer/iox)

This tutorial was developed and tested on OSX, using the software describd below. Most, if not all, of what works here will also work with Linux too, with informed adjustments.

#Software to Install

 - [XCode](https://developer.apple.com/xcode/), specifically for the command line utilities, including git, so that one can clone this repo, for example.
 - [VMWare Fusion](http://store.vmware.com/store/vmwde/en_IE/pd/productID.323416600) or [VirtualBox](https://www.virtualbox.org), suitable for running the [Yocto Build Appliance](https://www.yoctoproject.org/downloads/tools/jethro20/build-appliance-jethro-20). I used Fusion.
 - The [Yocto Build Appliance](https://www.yoctoproject.org/downloads/tools/jethro20/build-appliance-jethro-20), available from the [Yocto Tools page(]https://www.yoctoproject.org/downloads/tools). This is a matter of convenience, as one could also create one's own build appliance, but this is what I used.
 - The [sshpass](http://sourceforge.net/projects/sshpass/) utility, for convenience purposes only when VMs are being created and destroyed on a regular basis in development and test. WARNING, this is a hack around SSH, what one should do with Yocto images is described [in the Set Up SSH section of this post](https://maniacbug.wordpress.com/2012/08/03/yocto/).
 - [Homebrew](http://brew.sh), so that one can install [Qemu](http://wiki.qemu.org/Main_Page) and other Linux like utilities on OSX.
