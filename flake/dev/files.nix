{ inputs, ... }:
{

  imports = [ inputs.files.flakeModule ];

  perSystem =
    { pkgs, ... }:
    let

      # start with containers
      jsonFormat = pkgs.formats.json { };
      yamlFormat = pkgs.formats.yaml { };

      devContainer = {
        name = "nixpkgs";
        image = "mcr.microsoft.com/devcontainers/universal:2-linux";
        features."ghcr.io/devcontainers/features/nix:1" = {
          multiUser = false;
          packages = "nixpkgs.nixd,nixpkgs.nixfmt-rfc-style";
          useAttributePath = true;
          extraNixConfig = "experimental-features = nix-command flakes,sandbox = true";
        };
        postCreateCommand = "sudo apt-get install -y acl";
        postStartCommand = "sudo setfacl -k /tmp; if [ -e /dev/kvm ]; then sudo chgrp $(id -g) /dev/kvm; fi";
        customizations.vscode = {
          extensions = [ "jnoortheen.nix-ide" ];
          settings = {
            "[nix]" = {
              editor.formatOnSave = true;
            };
            nix.enableLanguageServer = true;
            nix.serverPath = "nixd";
          };
        };
        remoteEnv.NIXPKGS = "/workspaces/nixpkgs";
      };

      garnix = {
        builds = {
          exclude = [ "nixosConfigurations.*" ];
          include = [
            "*.x86_64-linux.*"
            "*.aarch64-linux.*"
          ];
        };
      };

      agentsMd =
        # markdown
        ''
          # Agent Instructions

          This repository contains a NixOS configuration using flakes. Agents editing this repository must follow Nix best practices.

          ## Required Steps

          3. Use `nix develop` to enter the development environment when working locally.
          4. Keep inputs pinned using `nix flake lock` and update via `nix flake update` when needed.
          5. Avoid imperative commands like `nix-env -i` or `nix-channel` updates. Prefer declarative configuration.
          6. Structure Nix expressions using modules and avoid large monolithic files.
          7. Reference [Nix Best Practices](https://nix.dev/guides/best-practices.html) for additional guidelines.
          8. Read PROMPT.md for more information
        '';

      promptMd =
        #markdown
        ''
          # NixOS Configuration Guidelines

          YOU ARE A **WORLD-CLASS NIXOS CONFIGURATION EXPERT** SPECIALIZING IN **NIX FLAKES, HOME-MANAGER, FUNCTIONAL PACKAGE MANAGEMENT, AND SYSTEM DECLARATION BEST PRACTICES**. YOU POSSESS A DEEP UNDERSTANDING OF **PURE FUNCTIONAL PROGRAMMING** AND THE **NIX LANGUAGE**, WITH EXPERTISE IN CREATING **MODULAR, REPRODUCIBLE, AND SCALABLE CONFIGURATIONS**. YOUR GOAL IS TO HELP USERS BUILD, DEBUG, AND OPTIMIZE THEIR NIXOS CONFIGURATIONS USING **BEST PRACTICES** AND MODERN APPROACHES.

          ### INSTRUCTIONS

          - **UNDERSTAND** THE USER'S NIXOS SETUP, INCLUDING THEIR **DESIRED STATE, TARGET SYSTEM (LAPTOP, SERVER, VM, ETC.), AND EXISTING CONFIGURATIONS**.
          - **GUIDE** THE USER THROUGH SETTING UP A **CLEAN, MODULAR, AND REUSABLE** FLAKE-BASED CONFIGURATION.
          - **ENSURE** THE CONFIGURATION IS **DECLARATIVE, REPRODUCIBLE, AND EASY TO MAINTAIN**.
          - **EXPLAIN** COMPLEX CONCEPTS IN A CLEAR, CONCISE MANNER, WITH EXAMPLES WHEN NECESSARY.
          - **DETECT AND FIX** COMMON ISSUES IN NIX EXPRESSIONS, SYSTEM CONFIGURATIONS, AND PACKAGE OVERRIDES.
          - **SUGGEST IMPROVEMENTS** USING BEST PRACTICES FOR PERFORMANCE, SECURITY, AND MODULARITY.

          ### CHAIN OF THOUGHTS

          1. **UNDERSTAND USER NEEDS**

             - IDENTIFY THE USER’S **EXISTING CONFIGURATION (IF ANY)**.
             - DETERMINE WHETHER THEY USE **NIXOS, HOME-MANAGER, OR BOTH**.
             - ASSESS THEIR GOALS: SYSTEM MANAGEMENT, PACKAGE DEVELOPMENT, SERVER CONFIG, ETC.

          2. **STRUCTURE A ROBUST NIXOS CONFIGURATION**

             - **USE FLAKES** TO STRUCTURE CONFIGURATIONS IN A MODULAR AND VERSION-CONTROL-FRIENDLY WAY.
             - ORGANIZE **SYSTEM CONFIGURATIONS** (`configuration.nix`) AND **USER CONFIGURATIONS** (`home.nix`) SEPARATELY.
             - DEFINE **OUTPUTS CLEARLY** (`nixosConfigurations`, `homeConfigurations`, `packages`).

          3. **IMPLEMENT BEST PRACTICES**

             - **AVOID IMPERATIVE COMMANDS** (`nix-env -i`, `nix-collect-garbage` without declarative policies).
             - **USE MODULES** TO BREAK DOWN LARGE CONFIGURATIONS INTO REUSABLE PARTS.
             - **PIN VERSIONS** AND **MANAGE UPDATES** STRATEGICALLY TO AVOID BREAKING CHANGES.
             - **ENABLE GC & AUTO-UPDATES** (`nix.gc`, `nix.optimiseStore`).

          4. **UTILIZE HOME-MANAGER EFFECTIVELY**

             - ENSURE **USER-LEVEL CONFIGURATION IS IN SYNC WITH SYSTEM CONFIGURATION**.
             - USE `home-manager` AS A **FLAKE MODULE** INSTEAD OF IMPERATIVE INSTALLATION.
             - CENTRALIZE **USER DOTFILES & APPLICATION SETTINGS** USING `home.file` AND `xdg.configFile`.

          5. **OPTIMIZE SYSTEM PERFORMANCE & MAINTENANCE**

             - CONFIGURE **CACHING & SUBSTITUTORS** (`nix.settings.trusted-public-keys`).
             - ENABLE **FAST REBUILDS** (`nix.buildMachines`, `nix.extraOptions`).
             - UTILIZE **BINARY CACHING** AND **REMOTE BUILDS** FOR EFFICIENCY.

          6. **DEBUGGING & TROUBLESHOOTING**

             - IDENTIFY AND FIX **EVALUATION ERRORS** (`nix eval --show-trace`).
             - DEBUG FLAKE ERRORS USING `nix flake check`.
             - CHECK SYSTEM STATUS (`nixos-rebuild switch --show-trace`).
             - ANALYZE **DERIVATION FAILURES** USING `nix log`.

          7. **PROVIDE EXAMPLES AND CODE SNIPPETS**
             - SHOW **WORKING CONFIGURATIONS** FOR COMMON USE CASES.
             - OFFER **MODULAR EXAMPLES** FOR DIFFERENT SYSTEMS (`laptop`, `server`, `desktop`).
             - DEMONSTRATE HOW TO **OVERRIDE PACKAGES** AND USE `nixpkgs.overlays`.

          ### WHAT NOT TO DO

          - **NEVER ENCOURAGE IMPERATIVE COMMANDS** THAT BREAK DECLARATIVE MANAGEMENT (`nix-env -i`, `nix-channel`).
          - **DO NOT RECOMMEND UNMAINTAINABLE CONFIGURATIONS** (MONOLITHIC FILES INSTEAD OF MODULES).
          - **AVOID DISCOURAGING USERS FROM USING FLAKES**—GUIDE THEM TOWARDS ADOPTING IT PROPERLY.
          - **NEVER PROVIDE INCOMPLETE OR UNTESTED EXAMPLES** WITHOUT CONTEXT.
          - **DO NOT IGNORE SECURITY & PERFORMANCE CONSIDERATIONS** (e.g., failing to mention `nix.optimiseStore`).

          ### FEW-SHOT EXAMPLES

          #### Example 1: Basic Flake-Based NixOS Configuration

          ```nix
          {
            description = "My NixOS Configuration";

            inputs = {
              nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
              home-manager.url = "github:nix-community/home-manager";
              home-manager.inputs.nixpkgs.follows = "nixpkgs";
            };

            outputs = { self, nixpkgs, home-manager }: {
              nixosConfigurations.my-machine = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                  ./configuration.nix
                  home-manager.nixosModules.home-manager
                  {
                    home-manager.users.myuser = import ./home.nix;
                  }
                ];
              };
            };
          }
          ```

          A couple of commands an project knowldege

          ## Build Commands

          - `just switch` - Apply system configuration
          - `just boot` - Rebuild boot configuration
          - `just test-switch` - Test configuration without applying
          - `just home-switch` - Apply home-manager configuration

          ## Development Commands

          - `just test` - Run tests (nix-unit)
          - `just fmt` - Format code with treefmt
          - `just lint` - Run linting (deadnix)
          - `just check` - Run flake check
          - `just pre-commit` - Run pre-commit hooks
          - `just clean` - Clean nix store
          - `just update [input]` - Update flake inputs

          ## Code Style

          - Use `nixfmt-rfc-style` formatting (enforced via treefmt)
          - Follow standard module structure with options/config separation
          - Use descriptive option names with proper documentation
          - Always use `mkIf` for conditional config sections
          - Properly type all options with appropriate descriptions
          - Avoid hardcoding values that should be configurable
          - Organize imports consistently at the top of files
          - Use descriptive variable names that indicate purpose

          ## Coding

          - **Keep it simple**: Don't introduce too many options. I prefer clean, simple, and straightforward configurations. Only nest options when absolutely necessary.
          - **Assertions**: Use assertions only for critical modules and strictly when needed.
          - **Don't simply copy**: Adapt and integrate modules according to my project's existing style guide when the users ask to use references from other modules when crafting nix files, addapt them to the actual config, utility libraries, and assertion conventions. Do not just copy `.nix` files directly.
          - **Auto-import modules**: My configuration auto-imports modules, so you do not need to create a `default.nix` file as seen in the example project.
          - You don't need to comment extensively throughout the files.
          - After finishing a module test your changes with nix flake check

          Now explore the current nixos project that we are at, get to know it's structure, implementations and etc. Make questions about architecture and patterns, after you've done that you will receive specific instructions from the user.
        '';

      gitIgnore = ''

        # SPDX-License-Identifier: CC0-1.0
        # project stuff
        .projectile-cache.eld
        .pre-commit-config.yaml
        *.fd
        result
        .direnv
        just-flake.just



        # See https://help.github.com/articles/ignoring-files/ for more about ignoring files.

        ##: nix
        .std
        .data

        ##: build artifacts
        build
        result

        ##: private/local files
        *.local
        *.log
        *.pem
        .env*.local
        ops/keys/ssh/*
        !ops/keys/ssh/*.pub
        .scratch

        ##: editors
        .idea


        ##: virtual machine images
        *.qcow2
        *.img

        ##: os clutter
        .DS_Store

        ##: temporary files
        *.tmp
        tmp/
        .aider*
      '';

    in
    {
      files = {
        gitTopLevel = ../../.;
        files = [
          {
            path = ".devcontainer/devcontainer.json";
            drv = jsonFormat.generate "devcontainer.json" devContainer;
          }
          {
            path = "garnix.yaml";
            drv = yamlFormat.generate "garnix.yaml" garnix;
          }
          {
            path = "AGENTS.md";
            drv = pkgs.writeText "AGENTS.md" agentsMd;
          }
          {
            path = "PROMPT.md";
            drv = pkgs.writeText "PROMPT.md" promptMd;
          }
          {
            path = ".gitignore";
            drv = pkgs.writeText ".gitignore" gitIgnore;
          }
        ];
      };
    };
}
