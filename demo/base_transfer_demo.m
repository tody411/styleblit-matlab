function base_transfer_demo(style_id,target_frame, sigma)
    % BASE_TRANSFER_DEMO Base layer transfer demo
    % 
    % Inputs:
    % - style_id: style id ['01', ..., '05']
    % - target_frame: target frame number [1, ..., 60]
    % - sigma: Gaussian filter parameter for base/detail layer separation
    %
    
    %% Load images
    [C_S, G_S, A_S] = load_style(style_id);

    [G_T, A_T] = load_target(target_frame);

    %% Separate base/detail layers
    [B_S, D_S] = separate_base_detail(C_S, sigma);

    %% Base layer transfer using Lit-Sphere
    B_T = base_transfer(B_S, G_S, G_T);

    %% Figure plot
    fig = figure('Name','Base Layer Transfer','NumberTitle','off');
    fig.Position = [0 0 800 300];

    margin = 0.05;

    subplottight(1, 4, 1, margin);
    imshow_alpha(B_S, A_S);
    title('B_S');

    subplottight(1, 4, 2, margin);
    imshow_alpha(G_S, A_S);
    title('G_S');

    subplottight(1, 4, 3, margin);
    imshow_alpha(G_T, A_T);
    title('G_T');

    subplottight(1, 4, 4, margin);
    imshow_alpha(B_T, A_T);
    title('B_T');

    set(findobj(gcf, 'Type', 'Axes'), 'FontSize', 15);

    %% Save figure.
    saveas(fig,sprintf('results/base_transfer_%s.png',style_id));
    
end

