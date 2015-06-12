{
  nixpkgs.config.packageOverrides = pkgs: rec {
    emacs = pkgs.stdenv.lib.overrideDerivation pkgs.emacs (oldAttrs : {
      makeFlags = "NO_BIN_LINK=t";
      installFlags = "NO_BIN_LINK=t";
    });

    localPackagesHome = "/home/nafai/Projects";

    emacs-server =
      pkgs.callPackage ..${localPackagesHome}/local-apps/emacs-server {};
    gtkmenu =
      pkgs.haskellPackages.callPackage ${localPackagesHome}/gtkmenu {};
    travis-hartwell-mail =
      pkgs.callPackage ${localPackagesHome}/local-apps/travis-hartwell-mail {};
  };
}
