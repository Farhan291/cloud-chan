{ pkgs, hermes-agent, ... }:

let
  # gateway connect to telegram
  telegramPythonPkg = pkgs.python312Packages.python-telegram-bot;
in
{
  #nix setting
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    git
    neovim
    curl
    wget
    ripgrep
    zoxide
    starship
    fastfetch
    htop
    unzip
    btop
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

  #swap
  swapDevices = [
    {
      device = "/swapfile";
      size = 2048;
    }
  ];

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
    telegram-env = {
      file = ../secrets/hermes.env.age;
      path = "/run/secrets/hermes.env";
    };
  };

  #nvim dotfiles
  system.activationScripts.dotfiles = ''
    if [ ! -d /root/.config/nvim ]; then
      ${pkgs.git}/bin/git clone git@github.com:Farhan291/dotfiles.git /tmp/dotfiles
      mkdir -p /root/.config
      cp -r /tmp/dotfiles/.config/nvim /root/.config/nvim
    fi
  '';

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

  #hermes-agent
  services.hermes-agent = {
    enable = true;
    environmentFiles = [ "/run/secrets/hermes.env" ];
    settings = {
      messaging = {
        telegram = {
          enable = true;
          token = "";
        };
      };
    };
  };

  # extend hermes systemd service with PYTHONPATH
  systemd.services.hermes-agent = {
    environment = {
      PYTHONPATH = "${telegramPythonPkg}/${pkgs.python312.sitePackages}";
    };
  };

  #kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "25.11";
}

