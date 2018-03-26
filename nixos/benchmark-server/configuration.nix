# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  #networking.networkmanager.enable = true;
  networking.hostName = "integrity"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  #networking.interfaces.eno1.ip4 = [ { address = "192.168.50.7"; prefixLength = 24; } ];
  #networking.defaultGateway = "192.168.50.1";
  #networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];
  #networking.interfaces.eno1.ip6 = [ { address = "2601:0281:8100:09CD:529A:4CFF:FE7B:5F59"; prefixLength = 64; } ];
  #networking.defaultGateway6 = {
  #  address = "2601::1";
  #  interface = "eno1";
  #};

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Denver";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
   let
     scalalauncher = import /etc/nixos/scalaLauncher.nix;
     benchmarkrunner = import /etc/nixos/benchmarkRunner.nix;
   in  (with pkgs; [
     git
     awscli
     wget
     vim
     jre
     tmux
     docker
     docker_compose
     curl
     jq
     file
     patchelf
  ]) ++ [ scalalauncher benchmarkrunner ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  # Configure cron
  services.cron = {
    enable = true;
    systemCronJobs = [
      "59 23 * * * sduser aws s3 sync /home/sduser/outputdata s3://slamdata-benchmarks-output"
    ];
  };

  # Edit NIX_PATH with ssh-config-file path
  # in order to allow fetchgitPrivate to pull slamdata repos
  nix.nixPath = options.nix.nixPath.default ++ [
   (let
     sshKey = pkgs.writeText "git_deploy" "/etc/ssh/ssh_host_rsa_key";

     sshConfigFile =
       pkgs.writeText "ssh_config" ''
         Host github.com
         IdentityFile /etc/ssh/ssh_host_rsa_key
         StrictHostKeyChecking=no
       '';
   in
     "ssh-config-file=${sshConfigFile}"
   )
  ];

  # docker virtualisation
  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  users.extraUsers.sduser = {
    isNormalUser = true;
    uid = 1000;
    createHome = true;
    home = "/home/sduser";
    description = "Slamdata User";
    extraGroups = [ "wheel" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
