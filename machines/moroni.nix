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
  };

  environment.systemPackages = with pkgs; [
    ## basic development tools
    vimNox

    ## Applications
    weechat
  ];

  services.fail2ban = {
    enable = true;
    jails.ssh-iptables =
      ''
        enabled  = true
        filter   = sshd
        action   = iptables[name=SSH, port=ssh, protocol=tcp]
        maxretry = 5
      '';
  };
}
