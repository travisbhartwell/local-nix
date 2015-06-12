{
  nixpkgs.config.packageOverrides = pkgs: rec {
    emacs = pkgs.stdenv.lib.overrideDerivation pkgs.emacs (oldAttrs : {
      makeFlags = "NO_BIN_LINK=t";
      installFlags = "NO_BIN_LINK=t";
    });

    gtkmenu = pkgs.haskellPackages.callPackage ../gtkmenu {};
    travis-hartwell-mail = pkgs.callPackage ../local-apps/travis-hartwell-mail {};
    emacs-server = pkgs.callPackage ../local-apps/emacs-server {};
  };
}
