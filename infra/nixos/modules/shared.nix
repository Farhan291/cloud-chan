{ pkgs, ... }:
{
  #nix setting
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
    ripgrep
    zoxide
    starship
    fastfetch
    htop
    unzip
  ];

  #bash
  programs.bash = {
    enable = true;
    interactiveShellInit = ''
      export TERM=xterm-256color
    '';
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch";
    };
  };

  #docker
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  #ufw
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      80
      443
    ];
  };

  #fail2ban
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "10m";
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  #secrets
  age.secrets = {
    postgres-env = {
      file = ../secrets/postgres.env.age;
      path = "/run/secrets/postgres.env";
    };
    umami-env = {
      file = ../secrets/umami.env.age;
      path = "/run/secrets/umami.env";
    };
    kcet-env = {
      file = ../secrets/kcet.env.age;
      path = "/run/secrets/kcet.env";
    };
  };

  #starship
  programs.starship = {
    enable = true;
    presets = [ "catppuccin-powerline" ];
  };

  #zoxide
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  #kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "25.11";
}
