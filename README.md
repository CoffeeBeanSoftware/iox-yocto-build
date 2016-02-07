# A Yocto Build for IOx

This project is a tutorial and instructions on how to build a x86_64 [Yocto](http://www.yoctoproject.org) image, potentially suitable for use with [Cisco's IOx platform.](https://communities.cisco.com/community/developer/iox)

This tutorial was developed and tested on OSX, using the software described below. Most, if not all, of what works here will also work with Linux too, with informed adjustments.

There are various parts to what follows:

 - [Creating a Yocto build appliance](CreatingBuildAppliance.md), which should be tackled first and
 is described [here](CreatingBuildAppliance.md).
 - Using that build appliance to build a Yocto image.
 - Testing the Yocto image with Qemu in OSX.
 - How the [build was configured](BuildConfiguration.md), which is discussed [here](BuildConfiguration.md).

Before continuing to what is below, make sure you have a [suitable
build appliance](CreatingBuildAppliance.md).

#Software to Install on OSX

 - [XCode](https://developer.apple.com/xcode/), specifically for the command line utilities, including git, so that one can clone this repo, for example.
 - [VMWare Fusion](http://store.vmware.com/store/vmwde/en_IE/pd/productID.323416600) or [VirtualBox](https://www.virtualbox.org), suitable for running the [build appliance](CreatingBuildAppliance.md). I used Fusion.
 - The [sshpass](http://sourceforge.net/projects/sshpass/) utility, for convenience purposes only when VMs are being created and destroyed on a regular basis in development and test. WARNING, this is a hack around SSH; what one should do with Yocto images is described in the [Set Up SSH section of this post](https://maniacbug.wordpress.com/2012/08/03/yocto/).
 - [Homebrew](http://brew.sh), so that one can install
   [Qemu](http://wiki.qemu.org/Main_Page) and other Linux like
   utilities on OSX.
 - Qemu   

#Overall Workflow

The basic steps to build a Yocto image and test it are:

 - Build an image on the build appliance.
 - Copy the image, using `scp` to the OSX host.
 - Run the image using `qemu`.
 - Use `ssh` to connect to the image and test.
 
The various parts of this are largely automated with scripts in this repository, which should be cloned to the build machine, and to the host.

#Building with the Build Appliance

You should have [created a build appliance](CreatingBuildAppliance.md) by this stage.

To execute a build, one should, either, use the terminal windows already available when one runs the Build Appliance, or 'ssh' to the Build Appliance from the host.

The terminals windows on the Build Appliance are accessed via the down arrow symbol in the top left of the VM UI. One, anyway has to use those terminal windows at least once with the `ifconfig` command to see the IP address of the VM on 'eth0'. Given that IP address, one can use an OSX terminal to connect to the Build Appliance like this:

`sshpass -p "builder" ssh -o StrictHostKeyChecking=no builder@<Your Build Appliance IP Address>`

If this is the first time that the Build Appliance has been used, one needs to clone this repository. The instructions below are for anonymous HTTP cloning.

```bash
cd
mkdir -p git
cd git
git clone http://github.com/DevOps4Networks/iox-yocto-build.git
```

Then one needs to set up the build environment with these commands:

```bash
cd ~/poky
. ./oe-init-build-env ~/git/iox-yocto-build/
```

One should expect to see something like the following, and have had the working directory changed to `~/git/iox-yocto-build`:

```bash
### Shell environment set up for builds. ###

You can now run 'bitbake <target>'

Common targets are:
    core-image-minimal
    core-image-sato
    meta-toolchain
    adt-installer
    meta-ide-support

You can also run generated qemu images with a command like 'runqemu qemux86'
```

Then one can:

`bitbake core-image-kernel-dev`

And expect to see something like:

```bash
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
```

The first build will need to populate various local caches, the 'downloads 'directory and the 'tmp' directory. That takes a long time the first time around. See the note above about enlarging the disk to 100GB. It is very tedious to have a build run for hours, and then fail for lack of disk space.
