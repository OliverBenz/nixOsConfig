{ pkgs, pkgs-unstable, ... } : 
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    oliver = {
      isNormalUser = true;
      description = "Oliver Benz";
      extraGroups = [ "networkmanager" "wheel" "video" ];
      packages = [
        # Essential
        pkgs.home-manager
        pkgs.brave
        pkgs.firefox
        pkgs.kdePackages.kate
        pkgs.mpv
        pkgs.gthumb
        pkgs.flameshot
        pkgs.kdePackages.okular
        pkgs.krita

        # Work
        pkgs.slack
        pkgs.bitwarden-desktop
        pkgs.libreoffice
        pkgs.thunderbird

        # Recreational
        pkgs.discord
        pkgs.obs-studio
        pkgs.spotify
        pkgs.stellarium

        # Development
        pkgs.jetbrains.clion
        pkgs.gcc13
		pkgs.zeal
        pkgs.cmake
        pkgs.gnumake
        pkgs.ninja
        pkgs.qt6.qtbase
        pkgs.qtcreator
        pkgs.sqlite
        pkgs.gtest
        pkgs.tcl
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

  environment.variables = {
    EDITOR = "vim";
    SQLite3_Library = "${pkgs.sqlite.out}"; # Library files
    SQLite3_Include = "${pkgs.sqlite.dev}"; # Header files
    SQLITE3_Binary = "${pkgs.sqlite.bin}";  # Binary files
    SQLite3_Root = "${pkgs.sqlite.bin}:${pkgs.sqlite.dev}:${pkgs.sqlite.out}";
  };
}
