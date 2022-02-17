{
  description = "RPi 3+ image for thermal printer photobooth";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; };

  outputs = { self, ... }@inputs:
    with inputs; {

      # nix build .#sd-image.config.system.build.sdImage
      sd-image = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [

          # {

          #   # nix build .#sd-image.config.system.build.sdImage
          #   # unzstd -d result/sd-image/nixos-sd-image-*-aarch64-linux.img.zst -o nixos-sd-image-aarch64-linux.img

          #   mayniklas = {
          #     locale.enable = true;
          #     nix-common.enable = true;
          #     openssh.enable = true;
          #     pi4b-common.enable = true;
          #     server-apps.enable = true;
          #     zsh.enable = true;
          #     users = {
          #       root.enable = true;
          #       nik.enable = true;
          #     };
          #   };

          #   networking = {
          #     hostName = "pi4b";
          #     interfaces.eth0 = { useDHCP = true; };
          #   };

          # }

          # ({ ... }: {
          #   imports = [{ nix.nixPath = [ "nixpkgs=${nixpkgs}" ]; }];
          #   system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          #   nix.registry.nixpkgs.flake = nixpkgs;
          # })

          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ./configuration.nix
          # ./sd-image.nix
          # (import (./machines + "/${x}/configuration.nix") { inherit self; })
        ];
      };

    };
}
