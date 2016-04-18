{ config, pkgs, ... }:

let
    dovecot_wrapper = pkgs.writeScript "dovecot-wrapper"
      ''
        #!${pkgs.stdenv.shell}
        exec ${pkgs.dovecot}/libexec/dovecot/imap -c ${config.services.dovecot2.configFile}
      '';
in {
  imports =
    [
      /etc/nixos/common/config.nix
      /etc/nixos/common/desktop.nix
    ];

    # I don't use the wireless card, so don't load it.
    boot.blacklistedKernelModules = [ "ath9k" ];
    boot.loader.grub.device = "/dev/sdb";

    hardware.opengl.driSupport32Bit = true;

    networking = {
      hostName = "shedemei";
      # Also allow ssh on port 2500, mpd, and weechat relay
      firewall.allowedTCPPorts = [ 2500 6600 8000 8001 ];
      extraHosts = builtins.readFile "/home/nafai/Projects/local-nix/machines/shedemei-hosts";
    };

    environment.systemPackages = with pkgs; [
      ## temporary
      ecryptfs

      ## Hardware Support
      libvdpau

      ## Music
      mpd
      mpc_cli
      ncmpcpp

      ## Email
      gnupg
      offlineimap
      w3m

      ## Applications
      ledger
      skype
      steam

      ## Applications for screencasting and livecoding
      byzanz-record-window
      obs-studio
      simplescreenrecorder
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
               server	"127.0.0.1"
        }

        audio_output {
               type		 "httpd"
               name		 "My HTTP Stream"
               encoder "vorbis"
               port		 "8000"
               bitrate "192"
               format	 "44100:16:1"
               }
      '';
    };

    # OpenSSH
    services.openssh.ports = [ 22 2500 ];

    # Also watch sdd
    services.smartd.devices = [
      { device = "/dev/sdd"; }
    ];

    # Enable udev rules for Android devices
    services.udev.packages = with pkgs; [ android-udev-rules ];
    # Add rule for the Firefox Flame phone
    services.udev.extraRules = ''
       ENV{adb_user}="yes"
       SUBSYSTEM=="usb", ATTRS{idVendor}=="05c6", SYMLINK+="android_adb"
       SUBSYSTEM=="usb", ATTRS{idVendor}=="18d1", SYMLINK+="android_fastboot"
    '';

    # Virtualbox
    virtualisation.virtualbox.host.enable = true;
    nixpkgs.config.virtualbox.enableExtensionPack = true;
    users.extraGroups.vboxusers.members = [ "nafai" ];

    # Xserver
    services.xserver.vaapiDrivers = with pkgs; [ vaapiIntel vaapiVdpau ];

    # Set up backup job
    systemd.services.home-backup = {
      enable = true;
      requires = [ "home.mount" "media-MyBook2TB.mount" ];
      description = "Backup my home directory";
      startAt = "*-*-* 01:00:00";
      path = with pkgs; [ rsync ];
      script = ''
        rsync -av --delete /home/nafai/ /media/MyBook2TB/Backup/shedemei/home/nafai/
      '';
    };

    systemd.services.offlineimap = {
      enable = false;
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      requires = [ "network-online.target" ];
      description = "Run offlineimap for nafai";
      path = [ pkgs.offlineimap ];
      environment.DOVECOT_WRAPPER = dovecot_wrapper;
      serviceConfig = {
        User = "nafai";
        ExecStart = ''${pkgs.offlineimap}/bin/offlineimap'';
        KillSignal = "SIGUSR2";
        Restart = "always";
      };
    };

    users.extraUsers."albino" = {
      isNormalUser = true;
      description = "albino";
      home = "/home/albino";
      shell = "/run/current-system/sw/bin/bash";
      uid = 1001;
    };
}
