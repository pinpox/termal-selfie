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
      nixosConfigurations.photobooth-pi = nixpkgs.lib.nixosSystem rec {
        system = "aarch64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ./configuration.nix
          {
            nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
            nix.registry.nixpkgs.flake = nixpkgs;
            sdImage.compressImage = false;
            sdImage.imageBaseName = "raspi-image";

            # Service
            systemd.services.photobooth = {
              wantedBy = [ "multi-user.target" ];
              after = [ "network.target" ];
              description = "Photobooth App";
              serviceConfig = {

                # Makes python output visible in the syslog
                Environment = [ "PYTHONUNBUFFERED=true" ];

                User = "root";
                ExecStart =
                  "${self.packages."${system}".photobooth-app}/bin/app.py";

                Restart = "on-failure";
                RestartSec = "5s";
              };
            };
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

          photobooth-app = pkgs.python3Packages.buildPythonApplication {
            pname = "photobooth-app";
            version = "1.0";

            propagatedBuildInputs = with pkgs.python3Packages; [
              python-periphery
              packages.python-escpos
              opencv4
            ];
            doCheck = false;
            src = ./photobooth-app;
          };

          # Generate a sd-card image for the pi
          # nix build '.#raspi-image'
          raspi-image =
            self.nixosConfigurations.photobooth-pi.config.system.build.sdImage;
        };

        apps = {
          # Actual photobooth application
          photobooth-app = flake-utils.lib.mkApp {
            drv = packages.photobooth-app;
            exePath = "/bin/app.py";
          };

          # Testing helper app, print a snapshot and exit
          photobooth-testprint = flake-utils.lib.mkApp {
            drv = packages.photobooth-app;
            exePath = "/bin/testprint.py";
          };
        };

        # `nix run` will print a testprint
        defaultApp = apps.photobooth-testprint;
        defaultPackage = packages.photobooth-app;
      });
}
