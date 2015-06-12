{ config, pkgs, ... }:

{
  imports =
    [
      ./common/config.nix
    ]

    boot.loader.grub.device = "/dev/sdb";

    networking = {
      hostName = "shedemei";
      # Also allow ssh on port 2500 and weechat relay
      firewall.allowedTCPPorts = firewall.allowedTCPPorts ++ [ 2500 8001 ];
    };

    environment.systemPackages = with pkgs; environment.systemPackages ++ [
      ## temporary
      ecryptfs

      ## Applications
      skype
      weechat
    ];

    services.openssh.ports = [ 22 2500 ];

    # Virtualbox
    services.virtualboxHost.enable = true;
    nixpkgs.config.virtualbox.enableExtensionPack = true;
    users.extraGroups.vboxusers.members = [ "nafai" ];

    services.smartd.devices =
      services.smartd.devices ++ [
        { device = "/dev/sdc"; }
        { device = "/dev/sdd"; }
      ];
}
