# home/profiles/htb.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nmap
    ffuf
    hashcat
    john
    # Add more CTF tools here
  ];
}
