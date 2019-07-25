function stylebilt_demo(style_id, target_frame, sigma, k, density)
    %STYLEBILT_DEMO Cluster-based StyleBilt demo
    %   
    % Inputs:
    % - style_id: style id ['01', ..., '05']
    % - target_frame: target frame number [1, ..., 60]
    % - sigma: Gaussian filter parameter for base/detail layer separation
    % - k: target number of clusters
    % - density: density of sampling exempler
    %
    
    %% Load images
    [C_S, G_S, A_S] = load_style(style_id);

    [G_T, A_T] = load_target(target_frame);

    %% Separate base/detail layers
    [B_S, D_S] = separate_base_detail(C_S, sigma);

    %% StyleBilt
    [C_T, B_T, D_T, idx] = stylebilt_cluster(B_S, D_S, G_S, G_T, A_T, k, density);
    L_c = label2rgb(idx);

    %% Figure plot
    fig = figure('Name','Cluster-Based Style Bilt','NumberTitle','off');
    fig.Position = [0 0 1000 600];
    margin = 0.05;

    subplottight(1, 5, 1, margin);
    imshow_alpha(C_S, A_S);
    title('C_S');

    subplottight(2, 5, 2, margin);
    imshow_alpha(B_S, A_S);
    title('B_S');

    subplottight(2, 5, 3, margin);
    imshow_alpha(B_T, A_T);
    title('B_T');

    subplottight(2, 5, 7, margin);
    imshow_alpha(0.5*(D_S+0.5), A_S);
    title('D_S');

    subplottight(2, 5, 8, margin);
    imshow_alpha(0.5*(D_T+0.5), A_T);
    title('D_T');

    subplottight(1, 5, 4, margin);
    imshow_alpha(L_c, A_T);
    title('Clusters');

    subplottight(1, 5, 5, margin);
    imshow_alpha(C_T, A_T);
    title('C_T');

    set(findobj(gcf, 'Type', 'Axes'), 'FontSize', 12);

    %% Save figure
    saveas(fig,sprintf('results/stylebilt_%s.png', style_id));

end

