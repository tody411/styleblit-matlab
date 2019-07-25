function imshow_alpha(C, A, B)
    %IMSHOW_ALPHA imshow with alpha mask.
    %   
    % Inputs:
    % - C: color image
    % - A: alpha image
    % - B: background image
    %
    if nargin < 3
        B = zeros(size(C));
    end
    imshow(B);
    hold on;
    h = imshow(C);
    set(h, 'AlphaData', A);
end

