function [C_T, B_T, D_T, idx] = stylebilt_cluster(B_S, D_S, G_S, G_T, A_T, k, density)
    %STYLEBILT_CLUSTER StyleBilt function using cluster-based approach.
    %
    % Inputs:
    % - B_S: style base layer
    % - D_S: style detail layer
    % - G_S: style guide
    % - G_T: target guide
    % - A_T: target alpha
    % - k: target number of clusters
    % - density: density of sampling exempler
    %
    % Outputs:
    % - C_T: target output
    % - B_T: target base layer
    % - D_T: target detail layer
    % - idx: cluster indices
    %
    if nargin < 6
        k = 200;
    end
    
    if nargin < 7
        density = 1.0;
    end
    
    %% Base layer transfer
    B_T = base_transfer(B_S, G_S, G_T);

    %% Detail layer transfer
    [D_T, idx] = detail_transfer(D_S, G_S, G_T, A_T, k, density);

    %% Compute final color
    C_T = B_T + D_T;
    C_T = clamp(C_T, 0, 1);

end




