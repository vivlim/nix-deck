
{ pkgs, lib, inputs, ... }: {
  time.timeZone = "America/Vancouver";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    rsync
    htop
    tmux
    file
    dnsutils
  ];

  nix = {
    # Enable nix flakes
    package = pkgs.nixStable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # Use system flake's nixpkgs input for nix cli tools, instead of channels
    # Needed to be able to use e.g. nix-shell on target machines.
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
    ];
  };

  system.stateVersion = lib.mkDefault "23.11"; # Did you read the comment?

}
