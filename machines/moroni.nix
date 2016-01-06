# Configuration for moroni, a VPS server.
{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      /etc/nixos/common/config.nix
    ];

  boot.loader.grub.device = "/dev/vda";

  networking = {
    hostName = "moroni";
    firewall.allowedTCPPorts = [ 80 443 ];
  };

  environment.systemPackages = with pkgs; [
    ## basic development tools
    vimNox

    ## Applications
    weechat
  ];

  services.fail2ban = {
    enable = true;
    jails.ssh-iptables = "enabled = true";
  };

  services.openssh = {
    permitRootLogin = "no";
    ports = [ 22 80 443 ];
  };
}
