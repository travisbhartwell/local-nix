pkgs: rec {
   # First, overrides of packages in nixpkgs
   emacs = pkgs.emacs.overrideDerivation (oldAttrs : {
     withGTK2 = false;
     withGTK3 = true;
     makeFlags = "NO_BIN_LINK=t";
     installFlags = "NO_BIN_LINK=t";
   });

   flashplayer = pkgs.flashplayer.overrideDerivation (attrs: rec {
     version = "11.2.202.491";
     src = pkgs.fetchurl {
       url = "http://fpdownload.adobe.com/get/flashplayer/pdc/${version}/install_flash_player_11_linux.x86_64.tar.gz";
       sha256 = "150zlnkq8jhhphfmyzdrpgi1y2sniqgx0a5ij994in3gvari9gpl";
     };
   });

   obs-studio = pkgs.obs-studio.override {
     pulseaudioSupport = true;
   };

   projectsHome = "/home/nafai/Projects";
   localPackagesHome = "${projectsHome}/local-apps";

   # Local Apps
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
   lowbrow-dev-env =
     pkgs.callPackage "${projectsHome}/lowbrow/Lowbrow.app" {};
}
