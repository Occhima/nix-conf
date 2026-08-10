# Shared Guernica QML primitives

These compositor-neutral services and widgets form Guernica's small QML
toolkit. Each variant exposes these files through repository links, so both
source roots can be passed directly to `quickshell -p`. Their Nix targets
materialize the links before applying the Guernica palette. Neither variant
imports or copies the other.
