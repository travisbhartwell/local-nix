{
  allowUnfree = true;

  firefox = {
    enableGoogleTalkPlugin = true;
    enableAdobeFlash = true;
  };

  packageOverrides = import /home/nafai/Projects/local-nix/common/pkg-overrides.nix;
}
