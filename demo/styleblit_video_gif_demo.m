function styleblit_video_gif_demo(style_id,sigma, k, density)
    % STYLEBILT_VIDEO_GIF_DEMO Cluster-based StyleBlit demo on video inputs.
    %
    % Inputs:
    % - style_id: style id ['01', ..., '05']
    % - sigma: Gaussian filter parameter for base/detail layer separation
    % - k: target number of clusters
    % - density: density of sampling exempler
    %
    fprintf('styleblit_video (%s): ',style_id);
    
    %% Load images
    [C_S, G_S, A_S] = load_style(style_id);

    %% Separate base/detail layers
    [B_S, D_S] = separate_base_detail(C_S, sigma);
    
    %% Prepare output
    out_file = sprintf('results/styleblit_%s.gif', style_id);
    fps = 12;
    num_samples = 30;
    frames_per_sample = 60/num_samples;
    frames = int32(linspace(1, 60, num_samples));
    delay_time = frames_per_sample / fps;

    %% Frame loop for StyleBlit process
    for frame=frames
        fprintf('*');

        [G_T, A_T] = load_target(frame);

        [C_T, B_T, D_T, idx] = styleblit_cluster(B_S, D_S, G_S, G_T, A_T, k, density);

        for ci=1:3
            C_T(:,:,ci) = C_T(:,:,ci) .* A_T;
        end
        
        [A,map] = rgb2ind(im2uint8(C_T),256);
        
        if frame==1
            imwrite(A,map,out_file,'gif','LoopCount',Inf,'DelayTime',delay_time);
        else
            imwrite(A,map,out_file,'gif','WriteMode','append','DelayTime',delay_time);
        end
    end
    
    fprintf(' (Completed)\n');
end

