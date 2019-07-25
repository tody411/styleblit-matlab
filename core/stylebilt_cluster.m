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

function [D_T, idx] = detail_transfer(D_S, G_S, G_T, A_T, k, density)
    % DETAIL_TRANSFER Detail transfer using cluster-based approach.
    %
    % Inputs:
    % - D_S: style detail layer
    % - G_S: style guide
    % - G_T: target guide
    % - A_T: target alpha
    % - k: target number of clusters
    % - density: density of sampling exempler
    %
    % Outputs:
    % - D_T: target detail layer
    % - idx: cluster indices
    
    
    [hs, ws, ~] = size(G_S);
    [ht, wt, ~] = size(G_T);
    
    [idx, G_c, P_c] = feature_clustering(G_T, A_T, k);
    
    D_T = zeros(ht, wt, 3);
    
    for py=1:ht
        for px=1:wt
            if A_T(py, px) == 0
                continue;
            end
            
            q = floor(P_c(py, px,1:2));
            
            q = reshape(q, 1, 2);
            q = [q(2) q(1)];
            p = [py px];
            
            uy = floor(hs*(1.0 - G_c(py,px,2)));
            uy = clamp(uy, 1, hs);
            ux = clamp(floor(ws*G_c(py,px,1)), 1, ws);
            
            u_q = [uy ux];
            
            u = u_q + density * (p-q);
            u = floor(u);
            
            u(1) = clamp(u(1), 1, hs);
            u(2) = clamp(u(2), 1, ws);
            
            D_T(py, px, :) = D_S(u(1), u(2), :);
        end
    end
end

function [idx, G_c, P_c] = feature_clustering(G, A, k)
    % FEATURE_CLUSTERING Feature clustering to generate chunks.
    %
    % Inputs:
    % - G: guide image
    % - A: alpha image
    % - k: target number of clusters
    %
    % Outputs:
    % - idx: cluster indices
    % - G_c: cluster center of guide feature in image.
    % - P_c: cluster center of position feature in image.
    
    sample_per_cluster = 32;
    
    [h, w, ~] = size(G);
    [P, scaler] = position_feature(h, w);
    
    w_P = 4.0;
    X = cat(3, G, w_P*P);
    X = reshape(X, h*w, []);
    A_X = reshape(A, h*w, []);
    X_roi = X(A_X>0.0, :);
    num_roi = size(X_roi,1);
    
    num_samples = sample_per_cluster * k;
    num_samples = min(num_samples, num_roi);

    sample_ids = randi(num_roi, num_samples, 1);
    X_samples = X_roi(sample_ids, :);
    
    [~,C] = kmeans(X_samples, k);
    idx = knnsearch(C, X);

    G_c = C(idx, 1:3);
    G_c = reshape(G_c, h, w, []);
    
    P_c = scaler * C(idx, 4:5) / w_P;
    P_c = reshape(P_c, h, w, []);

    idx = reshape(idx, h, w);
end


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
    P = cat(3, X, Y);
    scaler = sqrt(w*h);
    P = P / scaler;
end