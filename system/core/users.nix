{ pkgs, pkgs-unstable, ... } : 
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    oliver = {
      isNormalUser = true;
      description = "Oliver Benz";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = [
        # Essential
        pkgs.brave
        pkgs.kate
        pkgs.mpv
        pkgs.gthumb
        pkgs.flameshot
        pkgs.libsForQt5.okular
        pkgs.krita

        # Work
        pkgs.slack
        pkgs.whatsapp-for-linux
        pkgs.bitwarden
        pkgs-unstable.mathematica
        pkgs.libreoffice
        pkgs.thunderbird
        pkgs.calibre
        pkgs.onedrive

        # Recreational
        pkgs.discord
        pkgs.obs-studio
        pkgs.spotify

        # Development
        pkgs.jetbrains.clion
        pkgs.vscode
        pkgs.gcc13
        pkgs.sqlitecpp
        pkgs.cmake
        pkgs.gnumake
        pkgs.ninja
        pkgs.sqlite
        pkgs.qt6.full
      ];
    };

    guest = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [
        flameshot
      ];
      initialPassword = "guest";
    };
    
  };
}