{ pkgs, ... }:

{
  imports = [
    ./nix.nix
    ./docker.nix
    ./security.nix
    ./secrets.nix
    ./shell.nix
    ./bootstrap.nix
    ./packages.nix
    ./users.nix
    ./hermes.nix
    ./tailscale.nix
  ];
  #swap
  swapDevices = [
    {
      device = "/swapfile";
      size = 2048;
    }
  ];

  #kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "25.11";
}
