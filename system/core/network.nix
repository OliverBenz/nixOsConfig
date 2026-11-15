{
  networking.networkmanager.enable = true;

  # Tailnet. Its DNS (Pi-hole on the PC) resolves *.home to the PC.
  services.tailscale.enable = true;

  # Caddy's local CA, signs the *.home services (`tls internal`). Public cert, valid until 2036.
  security.pki.certificateFiles = [ ../../resources/caddy-root.crt ];
  # Node/Bun apps (e.g. opencode) ship their own CA list.
  environment.variables.NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/ca-certificates.crt";
}
