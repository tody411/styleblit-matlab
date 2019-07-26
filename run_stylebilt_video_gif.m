%% Cluster-Based StyleBilt Demo on Video Inputs

%% Parameter settings
sigma = 15;

k = 200;
density = 1.5;

%% Run Cluster-based StyleBilt demo on video inputs for each style_id ['01', ..., '05']
for id=1:2
    style_id = sprintf('%02d', id);
    stylebilt_video_gif_demo(style_id,sigma, k, density);
end
