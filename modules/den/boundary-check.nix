{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks.den-boundary = pkgs.runCommand "den-boundary" { nativeBuildInputs = [ pkgs.ripgrep ]; } ''
        cd ${inputs.self}/modules
        if rg -n --glob '*.nix' --glob '!den/**' \
          '\bden\.(aspects|hosts|homes|default|lib|schema|batteries|classes)\b|\{[^}]*\bden\b[^}]*\}:' .; then
          echo "Den vocabulary found outside modules/den/" >&2
          exit 1
        fi
        touch $out
      '';
    };
}
