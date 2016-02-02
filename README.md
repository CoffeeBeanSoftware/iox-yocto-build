# A Yocto Build for IOx

This project is a tutorial and instructions on how to build a x86_64 [Yocto](http://www.yoctoproject.org) image, potentially suitable for use with [Cisco's IOx platform.](https://communities.cisco.com/community/developer/iox)

This tutorial was developed and tested on OSX, using the software describd below. Most, if not all, of what works here will also work with Linux too, with informed adjustments.

#Software to Install

 - [XCode](https://developer.apple.com/xcode/), specifically for the command line utilities, including git, so that one can clone this repo, for example.
 - [VMWare Fusion](http://store.vmware.com/store/vmwde/en_IE/pd/productID.323416600) or [VirtualBox](https://www.virtualbox.org), suitable for running the [Yocto Build Appliance](https://www.yoctoproject.org/downloads/tools/jethro20/build-appliance-jethro-20). I used Fusion.
 - The [Yocto Build Appliance](https://www.yoctoproject.org/downloads/tools/jethro20/build-appliance-jethro-20), available from the [Yocto Tools page(]https://www.yoctoproject.org/downloads/tools). This is a matter of convenience, as one could also create one's own build appliance, but this is what I used.
 - The [sshpass](http://sourceforge.net/projects/sshpass/) utility, for convenience purposes only when VMs are being created and destroyed on a regular basis in development and test. WARNING, this is a hack around SSH, what one should do with Yocto images is described in the [Set Up SSH section of this post](https://maniacbug.wordpress.com/2012/08/03/yocto/).
 - [Homebrew](http://brew.sh), so that one can install [Qemu](http://wiki.qemu.org/Main_Page) and other Linux like utilities on OSX.

#Overall Workflow

The basic steps to build a Yocto image and test it are:

 - Build an image on the build appliance.
 - Copy the image, using `scp` to the OSX host.
 - Run the image using `qemu`.
 - Use `ssh` to connect to the image and test.
 
The various parts of this are largely automated with scripts in this repository, which should be cloned to the build machine, and to the host.

#Building with the Yocto Build Appliance

The [Yocto Build Appliance](https://www.yoctoproject.org/downloads/tools/jethro20/build-appliance-jethro-20) runs under VMware Fusion, and probably under VirtualBox also. VMware Fusion is required when using the Build Appliance to also run/test the built image, as that utilises "nested virtualisation" which is only supported by VMware Fusion. If you just use the Build Appliance to build, which is what these instructions guide one to do, then you could *probably* get away with VirtualBox alone.

The Build Appliance is designed to be used as a self-contained environment with a build wizard like utility called "Hob". That works just fine. What I explain below is the next stage, as it were, where one creates one's own customised build. That customised build is based on the files in the [conf](conf) directory in this project.

To execute a build, one should, either, use the terminal windows already available when one runs the Build Appliance, or 'ssh' to the Build Appliance from the host.

The terminals windows on the build apliance are accessed via the down arrow symbol in the top left of the VM UI. One, anyway has to use those terminal windows at least once with the 'ifconfig' command to see the IP address of the VM on 'eth0'. Given that IP address, one can use a OSX terminal to connect to the Build Appliance like this:

`sshpass -p "builder" ssh -o StrictHostKeyChecking=no builder@<Your Build Appliance Address>`

If this is the first time that the Build Appliance has been used, one needs to clone this repository. The instructions below are for anonymous HTTP cloning.

`bash
cd

mkdir -p git

cd git

git clone http://github.com/DevOps4Networks/iox-yocto-build.git
`

Then one needs to set up the build environment with these commands:

`bash
cd poky

. ./oe-init-build-env ~/git/iox-yocto-build/
`

One should expect to see the following, and have had the working directory changed to ~/git/iox-yocto-build/:

`bash
### Shell environment set up for builds. ###

You can now run 'bitbake <target>'

Common targets are:
    core-image-minimal
    core-image-sato
    meta-toolchain
    adt-installer
    meta-ide-support

You can also run generated qemu images with a command like 'runqemu qemux86'
`

Then one can:

`bitbake core-image-kernel-dev`

And expect to see something like:

`bash
Loaded 1330 entries from dependency cache.
NOTE: Resolving any missing task queue dependencies

Build Configuration:
BB_VERSION        = "1.28.0"
BUILD_SYS         = "x86_64-linux"
NATIVELSBSTRING   = "poky-2.0"
TARGET_SYS        = "x86_64-poky-linux"
MACHINE           = "qemux86-64"
DISTRO            = "poky"
DISTRO_VERSION    = "2.0.1"
TUNE_FEATURES     = "m64 core2"
TARGET_FPU        = ""
meta              
meta-yocto        
meta-yocto-bsp    = "jethro:049be17b533d7c592dae8e0f33ddbae54639a776"

NOTE: Preparing RunQueue
`

The first build will need to populate various local caches, the 'downloads 'directory and the 'tmp' directory. That takes a long time the first time around.
