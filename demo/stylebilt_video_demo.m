function stylebilt_video_demo(style_id,sigma, k, density)
    % STYLEBILT_VIDEO_DEMO Cluster-based StyleBilt demo on video inputs.
    %
    % Inputs:
    % - style_id: style id ['01', ..., '05']
    % - sigma: Gaussian filter parameter for base/detail layer separation
    % - k: target number of clusters
    % - density: density of sampling exempler
    %
    fprintf('stylebilt_video (%s): ',style_id);
    
    %% Load images
    [C_S, G_S, A_S] = load_style(style_id);

    %% Separate base/detail layers
    [B_S, D_S] = separate_base_detail(C_S, sigma);

    %% Prepare Video Writer
    video_writer = VideoWriter(sprintf('results/stylebilt_%s.mp4', style_id), 'MPEG-4');
    video_writer.FrameRate = 12;
    open(video_writer);

    %% Frame loop for StyleBilt process
    for frame=1:60
        fprintf('*');

        [G_T, A_T] = load_target(frame);

        [C_T, B_T, D_T, idx] = stylebilt_cluster(B_S, D_S, G_S, G_T, A_T, k, density);

        for ci=1:3
            C_T(:,:,ci) = C_T(:,:,ci) .* A_T;
        end

        writeVideo(video_writer, C_T);
    end

    close(video_writer);
    
    fprintf(' (Completed)\n');
end

