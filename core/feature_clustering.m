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