{ ... }:
{
  programs.bash = {
    enable = true;
    interactiveShellInit = ''
      export TERM=xterm-256color
    '';
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake";
      v = "nvim";
    };
  };

  programs.starship = {
    enable = true;
    presets = [ "catppuccin-powerline" ];
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };
}
