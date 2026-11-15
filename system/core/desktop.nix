{ pkgs, ... } :
{
  # X11 with the i3 window manager, as on the Manjaro PC. sddm stays the login screen.
  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "none+i3";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "at";
    variant = "";
  };

  # Everything the i3 config (home/dotfiles/i3Config) starts or binds to a key.
  environment.systemPackages = with pkgs; [
    kitty                     # terminal
    rofi                      # launcher
    polybar                   # bar
    picom                     # compositor
    dunst libnotify           # notifications
    nitrogen                  # wallpaper
    networkmanagerapplet      # nm-applet
    volumeicon alsa-utils pulseaudio  # tray volume, alsamixer, pactl
    playerctl                 # media keys
    xfce4-power-manager
    polkit_gnome              # authentication agent
    pcmanfm                   # file manager
    flameshot                 # screenshots
    i3lock                    # lock screen
    xkill xrandr
  ];

  # xbacklight for the brightness keys, with udev rules so the video group may write the backlight.
  hardware.acpilight.enable = true;

  # Monitor hotplug: an unknown screen (e.g. a projector) gets mirrored at the best common resolution.
  services.autorandr = {
    enable = true;
    defaultTarget = "common";
    hooks.postswitch.wallpaper = "${pkgs.nitrogen}/bin/nitrogen --restore";
  };

  # polkit-gnome installs its agent to libexec, which NixOS doesn't link into the system path by default.
  environment.pathsToLink = [ "/libexec" ];

  fonts.packages = with pkgs; [
    ghostscript.fonts         # URW Gothic, the i3 font
    nerd-fonts.jetbrains-mono
  ];
}
