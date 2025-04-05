# See flake.nix (just-flake)

import? 'just-flake.just'

flake_var := env_var('FLAKE')
flake := if flake_var =~ '^\.*$' { justfile_directory() } else { flake_var }

default:
    @just --list

# <- Reload direnv
[group('dev')]
reload:
    direnv reload
alias r:= reload

# <- Reload direnv and runs flake check
[group('dev')]
check:
    @just reload
    nix flake check --show-trace |& nom
alias ch := check

# <- Reload direnv and show current flake
[group('dev')]
show:
    nix flake show

# <- Reload direnv and runs nix-unit tests ( one day with namaka )
[group('dev')]
test:
    @just reload
    tests
alias t := test

#  <- Runs tree format
[group('dev')]
fmt:
    treefmt

# <- Locks all nix tree format
[group('dev')]
lock:
    nix flake lock
    nix flake lock ./flake/dev
alias lo := lock

# <- Inspects flake output
[group('dev')]
inspect:
    nix-inspect --path .



# <- Runs system lint
[group('dev')]
lint:
    deadnix .
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

# <- switch home-manager configuration
[group('rebuild')]
home-switch host="":
    home-manager switch --flake {{ flake }}#occhima@$([[ -z "{{host}}" ]] && hostname || echo "{{host}}")
alias hs := home-switch

# <- TODO Deploys the config on a machine using deploy-rs ( no remote build )
[group('rebuild')]
install host:
    deploy -cid {{host}}
alias i := install

# <- Deploys the config on a machine using nixos-install ( no remote build )
[group('rebuild')]
classic-install host:
    sudo nixos-install --flake {{ flake }}#{{host}} |& nom
alias ci := classic-install

# <- TODO: Deploys the config on a machine using disko-install ( this will also partition things )
[group('rebuild')]
partition-install host disk device:
    sudo nix run --experimental-features "nix-command flakes" 'github:nix-community/disko/latest#disko-install' -- --flake {{flake}}#{{ host }} --disk {{ disk }} {{device}} |& nom
alias pi := partition-install

# <- Partitions the disk using disko
[group("rebuild")]
partition disko_file:
    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount {{disko_file}}
alias pa := partition

# <- Builds home configuration
[group("rebuild")]
build-home home-config:
    nix run nixpkgs#home-manager -- switch -b backup --flake {{ flake }}#{{ home-config }}
alias bh := partition

# <- build the package, you must specify the package you want to build
[group('package')]
build pkg:
    nix build {{ flake }}#{{ pkg }} --log-format internal-json -v |& nom --json

# <- build the iso image, you must specify the image you want to build ( not working yet ) TODO
[group('package')]
iso image: (build "nixosConfigurations." + image + ".config.system.build.isoImage")

# <- build the .qcow2 image
[group('package')]
vm image: (build "nixosConfigurations." + image + ".config.system.build.vmWithDisko")

# <- run a VM for a specified host (defaults to face2face)
[group('package')]
run-vm host="face2face":
    nix run .#run-vm -- {{host}} |& nom

# <- build the tarball, you must specify the host you want to build ( not working yet ) TODO
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
