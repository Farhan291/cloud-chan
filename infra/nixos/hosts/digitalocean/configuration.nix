{ modulesPath, ... }:
{
  imports = [
    "${modulesPath}/virtualisation/digital-ocean-config.nix"
  ];

  networking = {
    hostName = "nixchan";
    useDHCP = true;
  };
}
