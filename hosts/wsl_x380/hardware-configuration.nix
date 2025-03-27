{ config, lib, pkgs, modulesPath, ... }:

{
    imports = [ ];

    boot.initrd.availableKernelModules = [ "virtio_pci" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    fileSystems."/lib/modules/5.15.167.4-microsoft-standard-WSL2" = {
        device = "none";
        fsType = "overlay";
    };

    fileSystems."/mnt/wsl" = {
        device = "none";
        fsType = "tmpfs";
    };

    fileSystems."/usr/lib/wsl/drivers" = {
        device = "drivers";
        fsType = "9p";
    };

    fileSystems."/" = {
        device = "/dev/disk/by-uuid/fd541083-6939-408d-b2ca-7a769f1d8c18";
        fsType = "ext4";
    };

    fileSystems."/mnt/wslg" = {
        device = "none";
        fsType = "tmpfs";
    };
    fileSystems."/mnt/wslg/distro" = {
        device = "/dev/sdd";
        fsType = "ext4";
        options = [ "ro" "relatime" "discard" "errors=remount-ro" "data=ordered" ];
    };

    fileSystems."/usr/lib/wsl/lib" = {
        device = "none";
        fsType = "overlay";
    };

    fileSystems."/tmp/.X11-unix" = {
        device = "/mnt/wslg/.X11-unix";
        fsType = "none";
        options = [ "bind" ];
    };

    fileSystems."/mnt/wslg/doc" = {
        device = "none";
        fsType = "overlay";
    };

    fileSystems."/mnt/c" = {
        device = "C:\134";
        fsType = "9p";
    };

    swapDevices = [
        { device = "/dev/disk/by-uuid/51ab5100-d138-4675-b1fc-7a38e1fe1bfc"; }
    ];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eth0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
