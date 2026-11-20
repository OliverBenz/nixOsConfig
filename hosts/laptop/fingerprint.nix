{ config, ... } :
let
  login = config.security.pam.services.login.rules.auth;
in
{
  services.fprintd.enable = true;

  # SDDM authenticates through the login stack. Password first, so a typed password works right away;
  # submitting an empty password falls through to the fingerprint reader.
  security.pam.services.login.fprintAuth = true;
  security.pam.services.login.rules.auth.fprintd.order = login.unix.order + 10;
}
