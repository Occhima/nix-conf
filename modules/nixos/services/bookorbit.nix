# BookOrbit: self-hosted ebook/audiobook/comic library platform (web app).
# Wraps nixpkgs' services.bookorbit, which provisions local postgres
# (pgvector, uuid-ossp, pg_trgm), runs migrations, and hardens the service.
# Secrets (JWT_SECRET, SETUP_BOOTSTRAP_TOKEN) go in services.bookorbit.environmentFile.
{
  flake.modules.nixos.bookorbit = {
    services.bookorbit.enable = true;
  };
}
