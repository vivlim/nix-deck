
{ config, pkgs, options, ... }: {
  services.openssh.enable = true;
  programs.ssh = {
    startAgent = true;
  };

  services.openssh.extraConfig = ''
    AcceptEnv COLORTERM
    AcceptEnv LANG
    AcceptEnv LC_CTYPE
    AcceptEnv LC_NUMERIC
    AcceptEnv LC_TIME
    AcceptEnv LC_COLLATE
    AcceptEnv LC_MONETARY
    AcceptEnv LC_MESSAGES
    AcceptEnv LC_PAPER
    AcceptEnv LC_NAME
    AcceptEnv LC_ADDRESS
    AcceptEnv LC_TELEPHONE
    AcceptEnv LC_MEASUREMENT
    AcceptEnv LC_IDENTIFICATION
    AcceptEnv LC_ALL
    AcceptEnv LC_TERMINAL
    AcceptEnv LC_TERMINAL_VERSION
  '';
}
