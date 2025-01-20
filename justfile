# See flake.nix (just-flake)

import? 'just-flake.just'

default:
    @just --choose

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
