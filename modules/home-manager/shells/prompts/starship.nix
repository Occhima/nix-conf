{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.shell;
  capitalize = str: strings.toUpper (builtins.substring 0 1 str) + builtins.substring 1 (-1) str;
in

{
  config = mkIf (cfg.prompt.type == "starship") {
    programs.starship = {
      package = pkgs.starship;
      enable = true;

      # Dynamically enable integration based on the selected shell
      "enable${capitalize cfg.type}Integration" = false;
      # enableZshIntegration = true;
      # Import your existing Starship config
      settings = {
        # Your existing format configuration
        format = ''
          $username\
          $hostname\
          $localip\
          $shlvl\
          $singularity\
          $kubernetes\
          $directory\
          $vcsh\
          $fossil_branch\
          $git_branch\
          $git_commit\
          $git_state\
          $git_metrics\
          $git_status\
          $hg_branch\
          $pijul_channel\
          $docker_context\
          $package\
          $c\
          $cmake\
          $cobol\
          $daml\
          $dart\
          $deno\
          $dotnet\
          $elixir\
          $elm\
          $erlang\
          $fennel\
          $golang\
          $guix_shell\
          $haskell\
          $haxe\
          $helm\
          $java\
          $julia\
          $kotlin\
          $gradle\
          $lua\
          $nim\
          $nodejs\
          $ocaml\
          $opa\
          $perl\
          $php\
          $pulumi\
          $purescript\
          $python\
          $raku\
          $rlang\
          $red\
          $ruby\
          $rust\
          $scala\
          $swift\
          $terraform\
          $vlang\
          $vagrant\
          $zig\
          $buf\
          $nix_shell\
          $conda\
          $meson\
          $spack\
          $memory_usage\
          $aws\
          $gcloud\
          $openstack\
          $azure\
          $env_var\
          $crystal\
          $custom\
          $sudo\
          $cmd_duration\
          $line_break\
          $jobs\
          $battery\
          $time\
          $status\
          $os\
          $container\
          $shell\
          $character
        '';

        # Rest of your starship config (condensed for brevity)
        # Custom commands
        "custom.git_server" = {
          disabled = true;
          description = "Display symbol for remote Git server";
          command = ''
            GIT_REMOTE=$(command git ls-remote --get-url 2> /dev/null)
            if [[ "$GIT_REMOTE" =~ "github" ]]; then
                GIT_REMOTE_SYMBOL=" "
            elif [[ "$GIT_REMOTE" =~ "gitlab" ]]; then
                GIT_REMOTE_SYMBOL=" "
            elif [[ "$GIT_REMOTE" =~ "bitbucket" ]]; then
                GIT_REMOTE_SYMBOL=" "
            elif [[ "$GIT_REMOTE" =~ "git" ]]; then
                GIT_REMOTE_SYMBOL=" "
            else
                GIT_REMOTE_SYMBOL=" "
            fi
            echo "$GIT_REMOTE_SYMBOL "
          '';
          when = "git rev-parse --is-inside-work-tree 2> /dev/null";
          style = "white";
          format = "[$output]($style) ";
        };

        # Core configurations
        battery = {
          full_symbol = "🔋";
          charging_symbol = "🔌";
          discharging_symbol = "⚡";
          display = [
            {
              threshold = 30;
              style = "bold red";
            }
          ];
        };

        cmd_duration = {
          min_time = 10000;
          format = "\\[[$duration]($style)\\]";
          style = "yellow";
        };

        memory_usage = {
          format = "\\[$symbol[$ram( | $swap)]($style)\\]";
          threshold = 70;
          style = "bold dimmed white";
          disabled = false;
        };

        directory = {
          truncation_length = 5;
          format = "[$path]($style)[$lock_symbol]($lock_style) ";
          substitutions = {
            "Documents" = " ";
            "Downloads" = " ";
            "Music" = " ";
            "Pictures" = " ";
          };
        };

        git_branch = {
          format = "\\[[$symbol$branch]($style)\\]";
          symbol = "🌱 ";
          style = "bold green";
        };

        git_status = {
          conflicted = "⚔️ ";
          ahead = "💨\${count} ";
          behind = "🐢\${count} ";
          diverged = "🔱 💨\${ahead_count} 🐢\${behind_count} ";
          untracked = "🛤️ \${count} ";
          stashed = "📦 ";
          modified = "📝\${count} ";
          staged = "🗃️ \${count} ";
          renamed = "📛\${count} ";
          deleted = "🗑️ \${count} ";
          style = "bright-white";
          format = "\\[ $all_status$ahead_behind\\]";
        };

        python = {
          format = "\\[[$symbol$pyenv_prefix($version)(\\($virtualenv\\))]($style)\\]";
          style = "bold green";
        };

        rust = {
          format = "\\[[$symbol($version)]($style)\\]";
          style = "bold green";
        };
      };
    };
  };
}
