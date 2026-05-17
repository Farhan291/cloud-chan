{
  description = "NixOS infra";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      #disk partitioning and filesystem management for nix
      url = "github:nix-community/disko";
      # it tells disko flake.nix to use my nixpkgs not ur own flake.nix nixpkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hermes-agent.url = "github:NousResearch/hermes-agent";
  };

  outputs =
    { nixpkgs
    , disko
    , agenix
    , hermes-agent
    , ...
    }:
    {
      nixosConfigurations = {
        azure = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            hermes-agent.nixosModules.default
            agenix.nixosModules.default
            disko.nixosModules.disko
            ./modules/shared.nix
            ./hosts/azure/configuration.nix
            ./hosts/azure/disk-config.nix
          ];
        };
      };
    };
}
