{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/common/config.nix
    ];

    boot.loader.grub.device = "/dev/sdb";

    networking = {
      hostName = "shedemei";
      # Also allow ssh on port 2500 and weechat relay
      firewall.allowedTCPPorts = [ 2500 8001 ];
    };

    environment.systemPackages = with pkgs; [
      ## temporary
      ecryptfs

      ## Applications
      ledger
      skype
      weechat
    ];

    services.openssh.ports = [ 22 2500 ];

    # Virtualbox
    services.virtualboxHost.enable = true;
    nixpkgs.config.virtualbox.enableExtensionPack = true;
    users.extraGroups.vboxusers.members = [ "nafai" ];

    # Also watch sdc and sdd
    services.smartd.devices = [
      { device = "/dev/sdc"; }
      { device = "/dev/sdd"; }
    ];

    # Set up backup job
    systemd.services.home-backup = {
      enable = true;
      description = "Backup my home directory";
      startAt = "*-*-* 01:00:00";
      path = with pkgs; [ rsync ];
      serviceConfig.ExecStart = ''
        rsync -av /home/nafai /media/MyBook2TB/Backup/shedemei/home/nafai
      '';
    };
}
