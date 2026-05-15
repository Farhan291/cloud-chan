{pkgs, ...} : {
    #nix setting
    nix.settings.experimental-features = ["nix-command" "flakes"];

    environment.systemPackages = with pkgs; [
        git
        vim
        curl
        wget
        docker
        ripgrep
        zoxide
        starship
        fastfetch
        htop
    ];

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
