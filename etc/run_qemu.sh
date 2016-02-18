/usr/local/bin/qemu-system-x86_64 -kernel images/bzImage-qemux86-64.bin -usb -redir tcp:5555::22 -netdev user,id=user.0 -device e1000,netdev=user.0 -drive file=images/core-image-kernel-dev-qemux86-64.ext4,if=virtio,format=raw -show-cursor -no-reboot -m 256 -serial mon:vc -serial null --append "vga=0 uvesafb.mode_option=640x480-32 root=/dev/vda rw mem=256M oprofile.timer=1 rootfstype=ext4 "


