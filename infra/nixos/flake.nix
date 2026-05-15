{
    description = "NixOS infra";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        disko={
             #disk partitioning and filesystem management for nix
            url = "github:nix-community/disko";
            # it tells disko flake.nix to use my nixpkgs not ur own flake.nix nixpkgs
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs, disko, ... }: {
        nixosConfigurations = {
            azure = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                disko.nixosModules.disko
                ./modules/shared.nix
                ./hosts/azure/configuration.nix
                ./hosts/azure/disk-config.nix
                ];
            };
        };
    };
}
