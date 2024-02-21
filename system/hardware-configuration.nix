# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];
 boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/5e503921-a17a-4a92-b453-731bc879ddc8"; # sda2
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/E5A6-23AE"; # sda4
      fsType = "vfat";
    };
  fileSystems."/home" = {
	device = "/dev/disk/by-uuid/ce6fb9ee-d258-47ff-801e-a851742cf2d0" # sda3
	fsType = "ext4";
  };
  fileSystems."/media/backups" = {
    device = "/dev/disk/by-uuid/4c491a88-7501-4b9c-acce-802cfa7b8e1b"; # sda1
    fsType = "btrfs";
    options = [ "x-systemd.automount" "noauto" "x-systemd.mount-timeout=90" ];
};

  # swapDevices = [ 
  # { device = "/dev/disk/by-uuid/cc45ddcf-6ad8-4152-a941-cd996045c1db"; # sda6
  #   size = 0;
  # }
  #   

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp7s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
