{
  nixpkgs.config.packageOverrides = pkgs: rec {
    gtkmenu = pkgs.haskellPackages.callPackage ../gtkmenu {};
    travis-hartwell-mail = pkgs.callPackage ../local-apps/travis-hartwell-mail {};
  };
}
