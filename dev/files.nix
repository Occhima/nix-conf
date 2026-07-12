{ inputs, ... }:
{

  imports = [ inputs.files.flakeModules.default ];

  perSystem =
    { pkgs, ... }:
    let
      # Only .gitignore is generated; AGENTS.md, PROMPT.md, garnix.yaml and
      # the devcontainer were declared here historically but never matched
      # the committed tree, so their checks could never pass.
      gitIgnore = ''
        # SPDX-License-Identifier: CC0-1.0
        # project stuff
        .projectile-cache.eld
        .pre-commit-config.yaml
        *.fd
        result
        .direnv
        .claude
        .omo
        data/


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
        /.agent-shell/
      '';
    in
    {
      files = {
        gitToplevel = ../.;
        files = [
          {
            path_ = ".gitignore";
            drv = pkgs.writeText ".gitignore" gitIgnore;
          }
        ];
      };
    };
}
