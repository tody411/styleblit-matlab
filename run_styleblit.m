%% Cluster-Based StyleBlit Demo

%% Parameter settings
sigma = 15;
target_frame = 1;

k = 200;
density = 1.5;

%% Run Cluster-based StyleBlit demo for each style_id ['01', ..., '05']
for id=1:5
    style_id = sprintf('%02d', id);
    styleblit_demo(style_id, target_frame, sigma, k, density);
end
