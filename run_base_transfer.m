%% Base Layer Transfer Demo

%% Parameter settings
sigma = 15;
target_frame = 1;

%% Run base layer transfer demo for each style_id ['01', ..., '05']
for id=1:5
    style_id = sprintf('%02d', id);
    base_transfer_demo(style_id,target_frame, sigma);
end