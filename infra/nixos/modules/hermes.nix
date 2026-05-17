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
      "skills/git/nixos-pr-workflow/SKILL.md" = ''''
        ---
        name: nixos-pr-workflow
        description: Workflow for making changes to the NixOS repository via Pull Requests.
        ---
        
        # NixOS PR Workflow
        
        When making changes to Light's NixOS repository, strictly follow this workflow.
        
        ## Rules
        1. **Never push directly to the main/master branch.**
        2. **Git Identity:** Always commit with the identity "Hermes Agent".
           ```bash
           git config user.name "Hermes Agent"
           ```
        3. **Always use Pull Requests:** Create a new branch, commit the changes, push the branch, and open a PR. Wait for Light to approve and merge it.
        
        ## Steps
        1. Create and checkout a new branch describing the change:
           `git checkout -b feature/description`
        2. Make necessary changes to the NixOS configuration.
        3. Stage changes: `git add .`
        4. Commit using the Hermes Agent identity:
           `git -c user.name="Hermes Agent" commit -m "feat: description"`
        5. Push the branch to the remote:
           `git push -u origin feature/description`
        6. Create a Pull Request (via `gh pr create` or equivalentREST/GUI).
        7. Notify Light that the PR is ready for approval. Once merged, the `deploy.yml` GitHub Action will handle deployment.
      ''';
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
