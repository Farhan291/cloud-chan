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
    # give full read/write to entire filesystem
    serviceConfig = {
      ProtectSystem = pkgs.lib.mkForce "no";
      ProtectHome = pkgs.lib.mkForce "no";
      ReadWritePaths = pkgs.lib.mkForce [ "/" ];
      NoNewPrivileges = pkgs.lib.mkForce false;
    };
  };

  services.hermes-agent = {
    enable = true;
    addToSystemPackages = true;

    # run as root for full permissions
    user = "root";
    group = "root";
    createUser = false;
    stateDir = "/root/hermes";

    # extra packages available to agent
    extraPackages = with pkgs; [
      git
      curl
      wget
      docker
      docker-compose
      jq
      ripgrep
      fd
      nodejs
      bash
    ];

    settings = {
      model = {
        provider = "copilot";
        default = "gemini-3.1-pro-preview";
      };

      terminal = {
        backend = "local";
        timeout = 300;
        lifetime_seconds = 600;
        cwd = "/root";
      };

      agent = {
        max_turns = 100;
        reasoning_effort = "high";
        restart_drain_timeout = 30;
      };

      memory = {
        memory_enabled = true;
        user_profile_enabled = true;
        memory_char_limit = 5000;
        nudge_interval = 5;
      };

      compression = {
        enabled = true;
        threshold = 0.85;
      };

      toolsets = [ "all" ];
    };

    # SOUL.md — agent personality
    documents = {
      "SOUL.md" = ''
        # Hermes — Light's Personal Server Agent

        You are a powerful AI agent running on Light's personal VPS (nixchan).
        You have full access to the server and can execute commands, manage docker
        containers, check logs, manage files, and perform any sysadmin task.

        ## Who you are talking to
        - Light — sophomore CS student, systems programmer, NixOS user
        - Interests: low-level C/systems programming, KVM/hypervisors, anime 
        - Uses Fedora + NixOS, Fish shell, Neovim, Zed

        ## Your capabilities
        - Full server access — run any command
        - Docker management — start/stop/inspect containers
        - Log inspection — check service health
        - File management — read/write any file
        - NixOS rebuilds — apply config changes
        - Backup management — trigger restic backups

        ## Your personality
        - Direct and technical — no fluff
        - Proactive — if you notice something wrong, mention it
        - Concise — short responses unless detail is needed

        ## Server context
        - OS: NixOS 26.05
        - Services: forgejo, umami, traefik, postgres
        - Config: /etc/nixos/
        - Services: /home/light/
        - Secrets: /run/secrets/
      '';
    };

    environmentFiles = [
      config.age.secrets.hermes-env.path
    ];
  };
}
