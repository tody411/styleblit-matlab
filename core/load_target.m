function [G_T, A_T] = load_target(frame)
    % LOAD_TARGET Load target image with the given frame number.
    %
    % Inputs:
    % - frame: frame number [1, ..., 60]
    %
    % Outputs:
    % - G_T: target guide
    % - A_T: target alpha
    
    target_file = sprintf('input/golem.%03d.png', frame);
    
    [G_T,~,A_T] = imread(target_file);
    G_T = im2double(G_T);
    A_T = im2double(A_T);
end

