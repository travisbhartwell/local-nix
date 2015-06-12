# Configuration common to all machines, intended for importing into the main
# configuration file.
{ config, pkgs, ... }:

{
  imports =
    [
      ../hardware.nix
      ./local-pkgs.nix
    ];

  nix.useChroot = true;

  nixpkgs.config = {
    allowUnfree = true;

    chromium = {
      enablePepperFlash = true;
      enablePepperPDF = true;
    };
  };

  boot.loader.grub = {
    enable = true;
    version = 2;
  };

  hardware.pulseaudio.enable = true;

  networking = {
    domain = "travishartwell.net";
    # Allow ssh and temporary web server
    firewall.allowedTCPPorts = [ 22 8888 ];
  };

  time.timeZone = "America/Denver";

  environment.systemPackages = with pkgs; [
    ## system level stuff
    usbutils
    lsof

    ## command line utilities
    aspell
    aspellDicts.en
    curl
    gist
    pypyPackages.pygments
    mr
    mtr
    silver-searcher
    mutt
    nix-repl
    tmux
    vcsh
    which

    ## basic development apps
    emacs
    emacs-server
    gitAndTools.gitFull
    vimHugeX

    ## Basic X
    gnome3.adwaita-icon-theme
    dmenu
    dunst
    gmrun
    gtkmenu
    i3
    i3status
    pa_applet
    rxvt_unicode-with-plugins
    xdotool
    xsel

    ## Applications
    chromiumBeta
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

  programs.bash.enableCompletion = true;

  security.setuidPrograms = [ "mtr" ];

  # Services
  services.openssh.enable = true;

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

    displayManager.slim = {
      enable = true;
      defaultUser = "nafai";
      autoLogin = true;
    };
  };

  users.extraUsers."nafai" = {
    isNormalUser = true;
    description = "Travis B. Hartwell";
    home = "/home/nafai";
    extraGroups = ["wheel"];
    shell = "/run/current-system/sw/bin/bash";
    uid = 1000;
  };
}
