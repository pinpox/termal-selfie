{
  description = "RPi 3+ image for thermal printer photobooth";

  inputs = {

    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    with inputs;
    rec {
      nixosConfigurations.photobooth-pi = sd-image;

      # nix build .#sd-image.config.system.build.sdImage
      sd-image = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ./configuration.nix
          {
            nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
            nix.registry.nixpkgs.flake = nixpkgs;
            sdImage.compressImage = false;
            sdImage.imageBaseName = "raspi-image";
          }
        ];
      };
    } //

    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};

      in rec {
        packages = flake-utils.lib.flattenTree rec {

          python-escpos = with pkgs.python3Packages;
            pkgs.python3Packages.buildPythonPackage rec {
              pname = "python-escpos";
              version = "2.2.0";

              src = pkgs.python3Packages.fetchPypi {
                inherit pname version;
                sha256 = "sha256-zmGWZ1t6mEame653dpd2l/UD2ugQMPHFMMH0/39SmDc=";
              };

              propagatedBuildInputs = [
                numpy
                setuptools_scm
                appdirs
                pyyaml
                qrcode
                pyserial
                argcomplete
                pyusb
                scripttest
                nose
                tox
                sphinx
                mock
                hypothesis
              ];

              # argparse is just required for python2.6
              prePatch = ''
                substituteInPlace setup.py --replace "'argparse'," ""
              '';

              # Checks try to write to $HOME, which does not work with nix
              doCheck = false;
            };

          photobooth-print = pkgs.python3Packages.buildPythonApplication {
            pname = "photobooth-print";
            version = "1.0";
            propagatedBuildInputs = with pkgs.python3Packages; [
              packages.python-escpos
              opencv4
            ];
            src = ./.;
          };

          photobooth-listen-test = pkgs.python3Packages.buildPythonApplication {
            pname = "photobooth-listen-test";
            version = "1.0";
            # propagatedBuildInputs = with pkgs.python3Packages; [
            #   packages.python-escpos
            #   opencv4
            # ];
              doCheck = false;
            src = ./.;
          };

          # photobooth-web = pkgs.python3Packages.buildPythonApplication {
          #   pname = "photobooth-web";
          #   version = "1.0";
          #   propagatedBuildInputs = with pkgs.python3Packages; [ flask ];
          #   src = ./.;
          # };

        };

        apps = {
          photobooth-print = flake-utils.lib.mkApp {
            drv = packages.photobooth-print;
            exePath = "/bin/print.py";
          };

          photobooth-listen-test = flake-utils.lib.mkApp {
            drv = packages.photobooth-listen-test;
            exePath = "/bin/test.py";
          };
        };

        # defaultApp = apps.photobooth-print;
        # defaultPackage = packages.photobooth-print;
      });
}
