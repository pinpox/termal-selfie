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

          # wp-gen    pkgs.python3Packages.buildPythonPackage rec {
          #           name = "getBook";
          #           src = ./.;
          #           propagatedBuildInputs = with python3Packages; [
          #             requests
          #             libgenApi
          #           ];
          #         };

          photobooth= pkgs.python3Packages.buildPythonApplication {
            pname = "demo-app";
            version = "1.0";
            propagatedBuildInputs =  with pkgs.python3Packages;[ flask ];
            src = ./.;
          };

        };
        defaultPackage = packages.photobooth;
      });
}
