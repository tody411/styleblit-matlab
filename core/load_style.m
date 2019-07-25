function [C_S, G_S, A_S] = load_style(style_id)
    % LOAD_STYLE Load style exempler with the given style id.
    %
    % Inputs:
    % - style_id: style id ['01', ..., '05']
    %
    % Outputs:
    % - G_S: style exempler
    % - G_S: style guide
    % - G_S: style alpha
    
    G_S = imread('styles/normal.png');
    G_S = im2double(G_S);

    [C_S,~,A_S] = imread(sprintf('styles/%s.png', style_id));

    C_S = im2double(C_S);
    A_S = im2double(A_S);
    [h,w,~] = size(C_S); 

    G_S = imresize(G_S, [h w]);
end

