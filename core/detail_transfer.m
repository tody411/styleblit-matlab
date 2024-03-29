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
    G_c_flat = reshape(G_c, ht*wt, []);
    P_c_flat = reshape(P_c, ht*wt, []);
    Q = floor(P_c_flat);
    
    Uy_q = floor(hs*(1.0 - G_c_flat(:,2)));
    Uy_q = clamp(Uy_q, 1, hs);
    Ux_q = clamp(floor(ws*G_c_flat(:,1)), 1, ws);
    U_q = cat(2, Uy_q, Ux_q);
    
    x = 1:wt;
    y = 1:ht;
    [Px,Py] = meshgrid(x,y);
    P = cat(3, Py, Px);
    P = reshape(P, [], 2);
    
    U = U_q + density * (P-Q);
    U = floor(U);
    U(:,1) = clamp(U(:,1), 1, hs);
    U(:,2) = clamp(U(:,2), 1, ws);
    
    D_S_flat = reshape(D_S, hs*ws, []);
    
    U_ids = sub2ind([hs ws], U(:,1), U(:,2));
    
    D_T_flat = D_S_flat(U_ids, :);
    
    D_T = reshape(D_T_flat, ht, wt, 3);
end


function [D_T, idx] = detail_transfer_slow(D_S, G_S, G_T, A_T, k, density)
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

