{ pkgs
, config
, ...
}:

let
  # gateway connect to telegram
  telegramPythonPkg = pkgs.python312Packages.python-telegram-bot;
in
{
  systemd.services.hermes-agent = {
    environment = {
      PYTHONPATH = "${telegramPythonPkg}/${pkgs.python312.sitePackages}";
    };
  };

  services.hermes-agent = {
    enable = true;
    addToSystemPackages = true;

    settings = {
      model = {
        provider = "copilot";
        default = "gemini-3.1-pro-preview";
      };

      terminal = {
        backend = "local";
        timeout = 180;
        lifetime_seconds = 300;
      };

      agent = {
        max_turns = 60;
        reasoning_effort = "medium";
      };

      memory = {
        memory_enabled = true;
        user_profile_enabled = true;
        memory_char_limit = 2200;
        nudge_interval = 10;
      };

      compression = {
        enabled = true;
        threshold = 0.85;
      };

      toolsets = [ "all" ];
    };

    environmentFiles = [
      config.age.secrets.hermes-env.path
    ];
  };
}
