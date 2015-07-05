{
  allowUnfree = true;

  packageOverrides = pkgs: {
    emacs-server = pkgs.callPackage /home/nafai/Projects/local-apps/emacs-server { };
    gospel-library-android = pkgs.callPackage /home/nafai/Projects/local-apps/android-gospel-library { };
    gtkmenu = pkgs.haskellPackages.callPackage /home/nafai/Projects/local-apps/gtkmenu { inherit (pkgs) dmenu; };
    travis-hartwell-mail = pkgs.callPackage /home/nafai/Projects/local-apps/travis-hartwell-mail { };

    iamtravis = pkgs.callPackage /home/nafai/Projects/blog/iamtravis { pygments = pkgs.python27Packages.pygments; };
    purescript-dev-env = pkgs.callPackage /home/nafai/Third-Party/Purescript/purescript-dev.nix { };
    lowbrow-dev-env = pkgs.callPackage /home/nafai/Projects/lowbrow/Lowbrow.app { };
  };
}
