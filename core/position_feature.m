function [P, scaler] = position_feature(h, w)
    % POSITION_FEATURE Postion feature of (h, w) size image.
    %
    % Inputs:
    % - h: image height
    % - w: image width
    %
    % Outputs:
    % P: position feature matrix
    % scaler: scaling factor to recover the original coordinates.
    %
    % Note: P is normalized with sqrt(w*h) close to [0 1] range.
    x = 1:w;
    y = 1:h;
    [X,Y] = meshgrid(x,y);
    P = cat(3, Y, X);
    scaler = sqrt(w*h);
    P = P / scaler;
end