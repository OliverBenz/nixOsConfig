{
  imports = [
    ./hardware-configuration.nix
    ./network.nix
    ./fingerprint.nix
  ];

  # Zed guesses 2x from the panel's ~200 DPI; every other app runs at 1x here.
  environment.sessionVariables.GPUI_X11_SCALE_FACTOR = "1";
}
