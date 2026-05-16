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

  users.users.root.openssh.authorizedKeys.keys = [
    # public ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO41eHK1TJDjfQE4xu8IDP1zMFEZqB8szQkGxjUMnuP2"
  ];

  # user -light
  users.users.light = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
  };
}
