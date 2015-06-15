# Configuration common to all machines, intended for importing into the main
# configuration file.
{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ./local-pkgs.nix
    ];

  nix.useChroot = true;

  nixpkgs.config.allowUnfree = true;

  boot.loader.grub = {
    enable = true;
    version = 2;
  };

  networking = {
    domain = "travishartwell.net";
    # Allow ssh and temporary web server
    firewall.allowedTCPPorts = [ 22 ];
  };

  time.timeZone = "America/Denver";

  environment.systemPackages = with pkgs; [
    ## system level stuff
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
  ];

  programs.bash.enableCompletion = true;

  security.setuidPrograms = [ "mtr" ];

  # Services
  services.openssh.enable = true;

  users.extraUsers."nafai" = {
    isNormalUser = true;
    description = "Travis B. Hartwell";
    home = "/home/nafai";
    extraGroups = ["wheel"];
    shell = "/run/current-system/sw/bin/bash";
    uid = 1000;
    openssh.authorizedKeys.keys = [
     ''
       ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGfGw56gbi6w4hkH/mIg2ELtNVfl62joj2MXJMaaye2hSGtsyQkpjPVM9KgPtbe06s4DmhuR52RWA8XnD2QqxXCxYeTnZ5a9InTJFds67BsDdxM1/gQy25AqmHb9Ohn1cJW3NqesXAHENTGQLyheEM2gRhfB3JwbzKJzrSPUFOKN4dsPt7lQVZ+IIURuSQnXmO3Zj3tymXv/heljnOT1QS6pQdBNiup9P1evE/PkZbJPfcaiNyRCIuM7P0dFLTBr8z8eVWlGFDT5x8kUbeU69YRg7wCd4MEatSk5EHvhm2zyeBdGi99roSCjLgB8I+cxGIXt5DN3TY1z0YJG4T1LcR nafai@shedemei
     ''
     ];
  };
}
