{pkgs, ...} : {
    #nix setting
    nix.settings.experimental-features = ["nix-command" "flakes"];

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

    #docker 
    virtualisation.docker = {
        enable = true;
        autoPrune.enable = true;
    };

    #ufw 
    networking.firewall = {
        enable = true;
        allowedTCPPorts = [22 80 443];
    };

    #fail2ban 
    services.fail2ban = {
        enable = true;
        maxretry =5;
        bantime = "10m";
    };

    services.openssh = {
        enable = true;
        settings = {
            PasswordAuthentication = false;
            PermitRootLogin = "prohibit-password";
        };
    };

    #kernel 
    boot.kernelPackages = pkgs.linuxPackages_latest;

    system.stateVersion = "25.11";
 }
