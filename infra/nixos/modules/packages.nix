{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    neovim
    curl
    wget
    ripgrep
    fastfetch
    htop
    unzip
    btop
    tree
  ];
}
