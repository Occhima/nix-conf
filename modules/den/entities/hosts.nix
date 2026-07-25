# Host inventory: declarative wiring of hosts to their users. The aspects of
# the same names (modules/den/aspects/) provide the actual configuration.
{
  den.hosts.x86_64-linux = {
    aerodynamic.users.occhima = { };
    beyond.users.occhima = { };
    crescendoll.users.occhima = { };
    steammachine.users.occhima = { };
    # Installer ISO builder — no regular user.
    voyager = { };
  };
}
