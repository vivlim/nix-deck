{ modulesPath, config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (retroarch.withCores (cores: with cores; [
        bsnes
        bsnes-mercury-balanced
        gambatte
        genesis-plus-gx
        gpsp
        mgba
        mupen64plus
        parallel-n64
        sameboy
        snes9x
        tgbdual
        vba-next
      ])
    )
  ];
}
