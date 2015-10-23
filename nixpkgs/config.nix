{
  allowUnfree = true;

  useChroot = true;
  binaryCaches =  [ "https://cache.nixos.org/" ];
  trustedBinaryCaches = [ "https://cache.nixos.org/" "https://hydra.nixos.org" ];
  binaryCachePublicKeys = [ "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs=" ];

  firefox = {
    enableGoogleTalkPlugin = true;
    enableAdobeFlash = true;
  };

  packageOverrides = import /home/nafai/Projects/local-nix/common/pkg-overrides.nix;
}
