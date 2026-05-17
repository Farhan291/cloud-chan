{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true; # grub for uefi
    efiInstallAsRemovable = true; # install bootloader in fallback efi path
    device = "nodev";
  };

  boot.initrd.availableKernelModules = [
    "hv_vmbus"
    "hv_storvsc"
    "hv_netvsc"
  ];

  networking = {
    hostName = "nixchan";
    useDHCP = true;
  };
}
