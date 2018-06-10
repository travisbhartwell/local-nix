# Common additional configuration for desktop and laptop machines.
{ config, pkgs, ... }:

{
  imports =
    [
      ./local-pkgs.nix
    ];

  # nixpkgs.config = {
  #   chromium = {
  #     enablePepperFlash = true;
  #     enablePepperPDF = true;
  #     enableWideVine = true;
  #   };
  # };

  hardware.pulseaudio.enable = true;

  # Allow temporary web server, syncthing, prometheus, and graphana
  networking.firewall.allowedTCPPorts = [ 3000 8888 9090 9091 9100 22000 ];
  networking.firewall.allowedUDPPorts = [ 21207 ];

  environment.systemPackages = with pkgs; [
    ## system level stuff
    pciutils
    usbutils

    ## Graphics utilities
    imagemagick

    ## basic devlopment apps
    vimHugeX
    nix-prefetch-scripts

    ## Emacs helpers
    ghostscript
    poppler_utils

    ## Basic X
    gnupg
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
    udiskie
    rxvt_unicode-with-plugins
    spaceFM
    xdotool
    xsel

    ## Applications
    chromium
    mpc_cli
    # travis-hartwell-mail
  ];

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      dejavu_fonts
      font-awesome-ttf
      hack-font
      powerline-fonts
      source-code-pro
      ubuntu_font_family
    ];
  };

  # gpg agent does this
  programs.ssh.startAgent = false;

  # Smart disk monitoring
  services.smartd = {
    enable = true;
    devices = [
      { device = "/dev/sda"; }
    ];
  };

  # Enable SyncThing
  # services.syncthing = {
  #   enable = true;
  #   user = "nafai";
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "caps:escape";
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
