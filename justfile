# See flake.nix (just-flake)

import? 'just-flake.just'

flake :=  justfile_directory()

default:
    @just --list

# <- Reload direnv
[group('dev')]
reload:
    direnv reload

# <- Reload direnv and runs flake check
[group('dev')]
check:
    @just reload
    nix flake check

# <- Reload direnv and show current flake
[group('dev')]
show:
    nix flake show

# <- Reload direnv and runs nix-unit tests ( one day with namaka )
[group('dev')]
test:
    @just reload
    tests

#  <- Runs tree format
[group('dev')]
fmt:
    treefmt

# <- Locks all nix tree format
[group('dev')]
lock:
    nix flake lock
    nix flake lock ./dev

# <- Inspects flake output
[group('dev')]
inspect:
    nix-inspect --path .



# <- Runs system lint
[group('dev')]
lint:
    deadnix .

# <- Runs configured pre commit
[group('dev')]
pc:
  pre-commit run


# <- clean the nix store and optimise it
[group('dev')]
clean:
    nh clean all -K 3d
    nix store optimise

# <- clean the nix store and optimise it the old way
[group('dev')]
oldclean:
    nix-collect-garbage
    nix store optimise

# <- setup our nixos builder
[group('rebuild')]
[linux]
[private]
builder goal *args:
    nh os {{ goal }} -- {{ args }}


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

# <- switch the new system configuration
[group('rebuild')]
switch *args: (builder "switch" args)


# <- build the package, you must specify the package you want to build
[group('package')]
build pkg:
    nix build {{ flake }}#{{ pkg }} --log-format internal-json -v |& nom --json

# <- build the iso image, you must specify the image you want to build ( not working yet )
[group('package')]
iso image: (build "nixosConfigurations." + image + ".config.system.build.isoImage")

# <- build the tarball, you must specify the host you want to build ( not working yet )
[group('package')]
tar host:
    sudo nix run {{ flake }}#nixosConfigurations.{{ host }}.config.system.build.tarballBuilder

[private]
verify *args:
    nix-store --verify {{ args }}

# <- repairs the nix store from any breakages it may have
[group('dev')]
repair: (verify "--check-contents --repair")
