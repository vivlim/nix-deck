{ modulesPath, config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture 
        obs-livesplit-one
        obs-vaapi
        obs-gstreamer
        input-overlay
        obs-3d-effect
        #obs-composite-blur # not on 23.11
        obs-gradient-source
        obs-vkcapture # Launch games with `obs-gamecapture %command%` to capture.
        waveform
      ];
    })
  ];
}
