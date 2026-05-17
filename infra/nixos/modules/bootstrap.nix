{ pkgs, ... }:
{
  system.activationScripts.dotfiles = ''
    if [ ! -d /root/.config/nvim ]; then
      ${pkgs.git}/bin/git clone https://github.com/Farhan291/dotfiles.git /tmp/dotfiles
      mkdir -p /root/.config
      cp -r /tmp/dotfiles/.config/nvim /root/.config/nvim
    fi
  '';
}
