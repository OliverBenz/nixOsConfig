# Not in nixos-26.05 yet, so module and package come from unstable.
# Settings are stateful, once per machine:
#   nordvpn login --token <token>
#   nordvpn set technology nordlynx
#   nordvpn set autoconnect on
#   nordvpn set firewall off   # its rules (kill switch included) drop Tailscale's traffic, which bypasses the tunnel
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
  # NordLynx routes everything but its own fwmark into the tunnel, so strict rpfilter
  # drops the encrypted replies arriving on the physical interface: no internet at all.
  networking.firewall.checkReversePath = "loose";

  # The module only allows set-dns-servers; nordvpnd also sets domains, default-route
  # and DNSSEC, and without those DNS keeps going to the LAN resolver and fails.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id.indexOf("org.freedesktop.resolve1.") == 0 && subject.user == "nordvpn") {
        return polkit.Result.YES;
      }
    });
  '';

  users.users.oliver.extraGroups = [ "nordvpn" ];
}
