flake_var := env_var_or_default('FLAKE', '')
flake := if flake_var =~ '^\.*$' { justfile_directory() } else { flake_var }

default:
    @just --list

# <- Reload direnv
[group('dev')]
reload:
    direnv reload
alias r := reload

# <- Reload direnv and runs flake check
[group('dev')]
check:
    @just reload
    nix flake check --show-trace |& nom
alias ch := check

# <- Reload direnv, runs flake-checker ( That's not nix flake check! )
[group('dev')]
flake-check:
    @just reload
    nix run github:DeterminateSystems/flake-checker
alias fc := flake-check

# <- Reloads all the checks: direnv, nix flake check and flake-checker
[group('dev')]
full-check:
    @just reload
    @just flake-check
    @just check
    @just fmt
alias fu := full-check

# <- Show current flake outputs
[group('dev')]
show:
    nix flake show

# <- Run nix-unit tests
[group('dev')]
unit-tests:
    @just reload
    nix-unit --flake .#tests
alias ut := unit-tests

# <- Runs tree format
[group('dev')]
fmt:
    treefmt

# <- Locks the root flake and the dev partition
[group('dev')]
lock:
    nix flake lock
    nix flake lock ./dev
alias lo := lock

# <- Inspects flake output
[group('dev')]
inspect:
    nix-inspect --path .

# <- Runs system lint
[group('dev')]
lint:
    deadnix .
    statix check .
alias l := lint

# <- Runs configured pre commit
[group('dev')]
pre-commit:
    pre-commit run
alias pc := pre-commit

# <- clean the nix store and optimise it
[group('dev')]
clean:
    nh clean all -K 3d
    nix store optimise
alias c := clean

# <- clean the nix store and optimise it the old way
[group('dev')]
oldclean:
    nix-collect-garbage
    nix store optimise
alias oc := oldclean

# <- setup our nixos builder
[group('rebuild')]
[linux]
[private]
builder goal *args:
    nh os {{ goal }} -- {{ args }}

# <- Rekey all agenix keys
[group('rebuild')]
rekey:
    agenix rekey -a
alias rk := rekey

# <- we have this setup incase i ever want to go back and use the old stuff
[group('rebuild')]
[linux]
[private]
classic goal *args:
    sudo nixos-rebuild {{ goal }} --flake {{ flake }} {{ args }} |& nom

# <- rebuild the boot
[group('rebuild')]
boot *args: (builder "boot" args)

# <- test what happens when you switch
[group('rebuild')]
test-switch *args: (builder "test" args)
alias ts := test-switch

# <- switch the new system configuration
[group('rebuild')]
switch *args: (builder "switch" args)
alias s := switch

# <- switch the standalone home-manager configuration
[group('rebuild')]
home-switch:
    home-manager switch --flake {{ flake }}#occhima
alias hs := home-switch

# <- Deploys the config on a machine using deploy-rs ( no remote build )
[group('rebuild')]
install host:
    deploy -cid {{ host }}
alias i := install

# <- Deploys the config on a machine using nixos-install ( no remote build )
[group('rebuild')]
classic-install host:
    sudo nixos-install --flake {{ flake }}#{{ host }} |& nom
alias ci := classic-install

# <- Deploys the config on a machine using disko-install ( this will also partition things )
[group('rebuild')]
partition-install host disk device:
    sudo nix run --experimental-features "nix-command flakes" 'github:nix-community/disko/latest#disko-install' -- --flake {{ flake }}#{{ host }} --disk {{ disk }} {{ device }} |& nom
alias pi := partition-install

# <- Partitions the disk using disko
[group("rebuild")]
partition disko_file:
    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount {{ disko_file }}
alias pa := partition

# <- Builds and activates a standalone home configuration
[group("rebuild")]
build-home home-config="occhima":
    nix run nixpkgs#home-manager -- switch -b backup --flake {{ flake }}#{{ home-config }}
alias bh := build-home

# <- build the package, you must specify the package you want to build
[group('package')]
build pkg:
    nix build {{ flake }}#{{ pkg }} --log-format internal-json -v |& nom --json

# <- build the iso image for an iso-class host (e.g. voyager)
[group('package')]
iso image: (build "nixosConfigurations." + image + ".config.system.build.isoImage")

# <- build the .qcow2 image
[group('package')]
vm image: (build "nixosConfigurations." + image + ".config.system.build.vmWithDisko")

# <- run a VM for a specified host
[group('package')]
run-vm host:
    nix run .#run-vm -- {{ host }} |& nom

# <- build the WSL tarball for a host (e.g. crescendoll)
[group('package')]
tar host:
    nix run {{ flake }}#nixosConfigurations.{{ host }}.config.system.build.tarballBuilder

[private]
verify *args:
    nix-store --verify {{ args }}
alias v := verify

# <- repairs the nix store from any breakages it may have
[group('dev')]
repair: (verify "--check-contents --repair")
alias re := repair

# update the lock file, if inputs are provided, only update those, otherwise update all
[group('dev')]
update *input:
    nix flake update {{ input }} --refresh
alias u := update
