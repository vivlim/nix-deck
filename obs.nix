{ modulesPath, config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture 
        obs-livesplit-one
        obs-multi-rtmp
        obs-vaapi
        obs-gstreamer
        input-overlay
        obs-3d-effect
        obs-composite-blur
        obs-gradient-source
        obs-vkcapture # Launch games with `obs-gamecapture %command%` to capture.
        waveform
      ];
    })
  ];
}
