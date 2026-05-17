{ ... }:
{
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

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      80
      443
    ];
  };

}
