{
  nixpkgs.config.packageOverrides = pkgs: rec {
    gtkmenu = pkgs.haskellPackages.callPackage ../gtkmenu {};
  };
}
