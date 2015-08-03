# Common additional configuration for desktop and laptop machines.
{ config, pkgs, ... }:

{
  imports =
    [
      ./local-pkgs.nix
    ];

  nixpkgs.config = {
    chromium = {
      enablePepperFlash = true;
      enablePepperPDF = true;
    };
  };

  hardware.pulseaudio.enable = true;

  # Allow temporary web server
  networking.firewall.allowedTCPPorts = [ 8888 ];

  environment.systemPackages = with pkgs; [
    ## system level stuff
    pciutils
    usbutils

    ## Graphics utilities
    imagemagick

    ## basic devlopment apps
    vimHugeX

    ## Emacs helpers
    ghostscript
    poppler_utils

    ## Basic X
    compton
    conky
    dmenu
    dunst
    gmrun
    gnome3.adwaita-icon-theme
    gnome3.gnome_themes_standard
    gtkmenu
    i3
    i3lock
    pa_applet
    rxvt_unicode-with-plugins
    python34Packages.udiskie
    xdotool
    xlibs.xmodmap
    xsel

    ## Applications
    chromiumBeta
    mpc_cli
    travis-hartwell-mail
  ];

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      dejavu_fonts
      source-code-pro
      ubuntu_font_family
    ];
  };

  # Smart disk monitoring
  services.smartd = {
    enable = true;
    devices = [
      { device = "/dev/sda"; }
    ];
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    autorun = true;

    windowManager = {
      i3.enable = true;
      default = "i3";
    };

    desktopManager.xterm.enable = false;

    displayManager.lightdm.enable = true;
  };

  # The user also needs to be in the audio and video groups
  users.extraUsers."nafai".extraGroups = [ "audio" "video" ];
}
