#What is a Yocto Build Appliance?

It is a Linux VM within which one builds Yocto. That simple really.

A pre-built  [Yocto Build Appliance](https://www.yoctoproject.org/downloads/tools/jethro20/build-appliance-jethro-20) is available from the [Yocto Tools page](https://www.yoctoproject.org/downloads/tools). That is perfectly OK for many purposes, up to the capacity of the ~40GB HDD that it is configured with. Since this tutorial requires more disk space, instructions for creating one's own build appliance are provided here.

Note that it is technically possible to grow the size of a VM's disk, and to grow partitions within a Linux VM to use that expanded disk size. That is fiddly though, so creating a build appliance from scratch is a simpler path.

One aspect of the [Yocto Build Appliance](https://www.yoctoproject.org/downloads/tools/jethro20/build-appliance-jethro-20) that is special is that it also provides a means to test the built images. Because of that, it is recommended to run it using [VMware Fusion](https://en.wikipedia.org/wiki/VMware_Fusion) as VMware supports "nested virtualisation", i.e running a VM within a VM. If you just use the Build Appliance to build, which is what these instructions guide one to do, then you could *probably* get away with [VirtualBox](https://www.virtualbox.org), which is free.

#Creating a Build Appliance

These instructions are based on using a [Ubuntu Desktop](http://www.ubuntu.com/download/desktop). The only reason I used that was because I am used to using the desktop terminal to find the IP address of the VM after startup, then I use SSH to connect to the VM from my OSX terminal. So, your Linux of choice will probably work for you, though note that the instructions below use [APT](https://wiki.debian.org/Apt) commands.

After downloading the ISO, use it to create a new VM in your hypervisor of choice. To be consistent with the Yocto Build Appliance, I used a user name of "builder" and a password of "builder", simply because I had already written some scripts and automation around those credentials.

After starting up the resulting VM, I carried out the following steps using a terminal in the desktop of the VM:

```bash
sudo apt-get -y install open-ssh
sudo /etc/init.d/ssh start
ifconfig eth0
```

From that point I was able to use SSH to connect to the VM, at the IP address shown by the `ifconfig eth0` command, from my OSX terminal, which is a more convenient way to work. To make that even more convenient, I used `sshpass` like this:

`sshpass -p "builder" ssh -o StrictHostKeyChecking=no builder@192.168.255.142`

Note that using `sshpass` is a hack around SSH security, and that one should [create a SSH key](https://help.github.com/articles/generating-a-new-ssh-key/) and copy the public key to the VM. In my defence, I don't do that under these circumstances as VMs tend to come and go on a regular basis.

Once connected to the VM via the terminal, I carried out the following steps to install the software required to make the VM a build machine:

```bash
sudo apt-get -y install git g++ libsdl1.2-dev texinfo gawk chrpath
mkdir -p ~git
cd ~git
git clone git://git.yoctoproject.org/poky
cd poky/
git checkout jethro
cd ~/git
git clone http://github.com/DevOps4Networks/iox-yocto-build.git
cd ~/git/poky
. ./oe-init-build-env ~/git/iox-yocto-build/
cd ~/git
git clone git://git.openembedded.org/meta-openembedded
git clone git://github.com/meta-qt5/meta-qt5.git
git clone git://git.openembedded.org/openembedded-core oe-core
cd oe-core
git checkout jethro
cd ~/git/poky
source ./oe-init-build-env /home/builder/git/iox-yocto-build/
cd ~/git/iox-yocto-build/
```

Then one can `bitbake core-image-kernel-dev`.

That's it.


