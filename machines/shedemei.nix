{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/common/config.nix
      /etc/nixos/common/desktop.nix
    ];

    # I don't use the wireless card, so don't load it.
    boot.blacklistedKernelModules = [ "ath9k" ];
    boot.loader.grub.device = "/dev/sdb";

    networking = {
      hostName = "shedemei";
      # Also allow ssh on port 2500, mpd, and weechat relay
      firewall.allowedTCPPorts = [ 2500 6600 8001 ];
    };

    environment.systemPackages = with pkgs; [
      ## temporary
      ecryptfs

      ## Music
      mpd
      mpc_cli
      ncmpcpp

      ## Applications
      ledger
      skype
      weechat
    ];

    hardware.pulseaudio.package = pkgs.pulseaudioFull;

    # Dovecot IMAP server
    services.dovecot2 = {
      enable = true;
      enableImap = true;
      mailLocation = "maildir:~/Mail";
    };

    # MPD
    services.mpd = {
      enable = true;
      extraConfig = ''
        audio_output {
               type		"pulse"
               name		"Local Music Player Daemon"
               server		"127.0.0.1"
        }
      '';
    };

    # OpenSSH
    services.openssh.ports = [ 22 2500 ];

    # Also watch sdc and sdd
    services.smartd.devices = [
      { device = "/dev/sdc"; }
      { device = "/dev/sdd"; }
    ];

    # Enable udev rules for Android devices
    services.udev.packages = with pkgs; [ android-udev-rules ];
    # Add rule for the Firefox Flame phone
    services.udev.extraRules = ''
       ENV{adb_user}="yes"
       SUBSYSTEM=="usb", ATTRS{idVendor}=="05c6", SYMLINK+="android_adb"
       SUBSYSTEM=="usb", ATTRS(idVender)=="18d1", SYMLINK+="android_fastboot"
    '';

    # Virtualbox
    services.virtualboxHost.enable = true;
    nixpkgs.config.virtualbox.enableExtensionPack = true;
    users.extraGroups.vboxusers.members = [ "nafai" ];

    # Xserver
    services.xserver.vaapiDrivers = with pkgs; [ vaapiIntel vaapiVdpau ];

    # Set up backup job
    systemd.services.home-backup = {
      enable = true;
      description = "Backup my home directory";
      startAt = "*-*-* 01:00:00";
      path = with pkgs; [ rsync ];
      script = ''
        rsync -av --delete /home/nafai/ /media/MyBook2TB/Backup/shedemei/home/nafai/
      '';
    };
}
