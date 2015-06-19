{
  packageOverrides = pkgs: {
    travis-hartwell-mail = pkgs.callPackage /home/nafai/Projects/local-apps/travis-hartwell-mail { };
    emacs-server = pkgs.callPackage /home/nafai/Projects/local-apps/emacs-server { };
    gtkmenu = pkgs.haskellPackages.callPackage /home/nafai/Projects/local-apps/gtkmenu { inherit (pkgs) dmenu; };
    iamtravis = pkgs.callPackage /home/nafai/Projects/blog/iamtravis { pygments = pkgs.python27Packages.pygments; };
  };
}
