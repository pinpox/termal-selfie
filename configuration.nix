{ config, pkgs, lib, ... }: {

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      (pkgs.fetchurl {
        url = "https://github.com/mayniklas.keys";
        sha256 = "174dbx0kkrfdfdjswdny25nf7phgcb9k8i6z3rqqcy9l24f8xcp3";
      })
    ];
  };

  nix.allowedUsers = [ "root" ];

  networking = {
    hostName = "pi4b";
    interfaces.eth0 = { useDHCP = true; };
  };

  # Set your time zone.
  time = { timeZone = "Europe/Berlin"; };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    startWhenNeeded = true;
    challengeResponseAuthentication = false;

  };

  boot = {
    loader = {
      raspberryPi = {
        firmwareConfig = ''
          dtparam=poe_fan_temp0=50000
          dtparam=poe_fan_temp1=60000
          dtparam=poe_fan_temp2=70000
          dtparam=poe_fan_temp3=80000
        '';
      };
    };
  };

  # Required for the Wireless firmware
  hardware.enableRedistributableFirmware = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  # nix
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      # Free up to 1GiB whenever there is less than 100MiB left.
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
    # Save space by hardlinking store files
    autoOptimiseStore = true;
    # Clean up old generations after 30 days
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  ##############################

  # boot.kernelPackages = pkgs.linuxPackages_rpi3;
  # environment.systemPackages = with pkgs; [ libraspberrypi ];

  # File systems configuration for using the installer's partition layout
  # fileSystems = {
  #   "/boot" = {
  #     device = "/dev/disk/by-label/NIXOS_BOOT";
  #     fsType = "vfat";
  #   };
  #   "/" = {
  #     device = "/dev/disk/by-label/NIXOS_SD";
  #     fsType = "ext4";
  #   };
  # };

  # boot.supportedFilesystems = ["ext4"];

  # Preserve space by sacrificing documentation and history
  # documentation.nixos.enable = false;
  # nix.gc.automatic = true;
  # nix.gc.options = "--delete-older-than 30d";
  # boot.cleanTmpDir = true;

  # Use 1GB of additional swap memory in order to not run out of memory
  # when installing lots of things while running other things at the same time.
  # swapDevices = [{ device = "/swapfile"; size = 1024; }];

}
