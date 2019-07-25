function [B, D] = separate_base_detail(I, sigma)
    % SEPARATE_BASE_DETAIL Separate base/detail layers from input image.
    %
    % Inputs:
    % - I: input image
    % - sigma: Gaussian filter parameter
    %
    % Outputs:
    % - B: base layer
    % - D: detail layer
    %
    B = imgaussfilt(I, sigma);
    D = I - B;
end