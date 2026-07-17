# Aggregate: personal data management — XDG layout, persistence,
# Dropbox (maestral) and mail accounts.
{ occhima, ... }:
{
  occhima.data-core.includes = with occhima; [
      xdg
      persistence
      maestral
      email
    ];
}
