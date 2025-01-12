# See flake.nix (just-flake)
import? 'just-flake.just'

# Display the list of recipes
[group('summary')]
default:
    @just --list
