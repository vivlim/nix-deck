{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.viv.defaultSwap;
in
{
  options.viv.defaultSwap = {
    enable = mkOption {
      default = true;
      example = true;
      type = types.bool;
      description = (lib.mdDoc "some ok defaults for swap. don't deploy machines without swap especially if they have low memory!");
    };

    swapfileSize = mkOption {
      type = types.int;
      default = 1024;
      description = lib.mdDoc "How large of a swapfile to use (in mb)";
    };
  };

  config = lib.mkIf cfg.enable {
    zramSwap.enable = mkDefault true;
    swapDevices = [{
      device = mkDefault "/swapfile";
      size = mkDefault cfg.swapfileSize;
    }];
  };
}
