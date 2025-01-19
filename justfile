# See flake.nix (just-flake)
import? 'just-flake.just'

# Display the list of recipes
[group('summary')]
default:
    @just --list

# Reload direnv
[group('dev')]
reload:
    direnv reload

# Reload direnv and runs flake check
[group('dev')]
check:
    @just reload
    nix flake check

# Reload direnv and show current flake
[group('dev')]
show:
    nix flake show

# Reload direnv and runs nix-unit tests
[group('dev')]
test:
    @just reload
    tests

# runs tree format
[group('dev')]
fmt:
    treefmt

# Locks all nix tree format
[group('dev')]
lock:
    nix flake lock
    nix flake lock ./dev
