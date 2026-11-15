# Not in nixos-26.05 yet, so module and package come from unstable.
# Settings are stateful, once per machine:
#   nordvpn login --token <token>
#   nordvpn set technology nordlynx
#   nordvpn set autoconnect on
#   nordvpn set killswitch on
{ inputs, pkgs-unstable, ... }:
let
  module = import "${inputs.nixpkgs-unstable}/nixos/modules/services/networking/nordvpn.nix";
in
{
  # Without its meta: the module's manual page is unknown to the stable manual and fails its build.
  imports = [ ({ config, lib, pkgs, ... }@args: removeAttrs (module args) [ "meta" ]) ];

  services.nordvpn = {
    enable = true;
    package = pkgs-unstable.nordvpn;
  };
  networking.firewall.enable = true;

  users.users.oliver.extraGroups = [ "nordvpn" ];
}
