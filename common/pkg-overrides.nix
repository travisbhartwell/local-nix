pkgs: rec {
   # First, overrides of packages in nixpkgs
   emacs = pkgs.emacs.overrideDerivation (oldAttrs : {
     withGTK2 = false;
     withGTK3 = true;
   });

   mumble = pkgs.mumble.override {
     pulseSupport = true;
   };

   obs-studio = pkgs.obs-studio.override {
     pulseaudioSupport = true;
   };

   projectsHome = "/home/nafai/Projects";
   localPackagesHome = "${projectsHome}/local-apps";

   # Local Apps
   byzanz-record-window =
     pkgs.callPackage "${localPackagesHome}/byzanz-record-window" {};
   emacs-server =
     pkgs.callPackage "${localPackagesHome}/emacs-server" {};
   gtkmenu =
     pkgs.haskellPackages.callPackage "${localPackagesHome}/gtkmenu" {};
   travis-hartwell-mail =
     pkgs.callPackage "${localPackagesHome}/travis-hartwell-mail" {};

   # Blog
   iamtravis =
     pkgs.callPackage "${projectsHome}/blog/iamtravis" {
       pygments = pkgs.python27Packages.pygments;
     };

   # Lowbrow
   #lowbrow-dev-env =
   #  pkgs.callPackage "${projectsHome}/lowbrow/Lowbrow.app" {};
}
