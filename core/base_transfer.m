function B_T = base_transfer(B_S, G_S, G_T)
    % BASE_TRANSFER Base layer transfer via Lit-Sphere.
    %
    % Inputs:
    % - B_S: style base layer
    % - G_S: style guide
    % - G_T: target guide
    %
    % Outputs:
    % - B_T: target base layer
    %
    [hs, ws, ~] = size(G_S); 
    [ht, wt, ~] = size(G_T);
    
    Qy = floor(hs*(1.0 - G_T(:,:,2)));
    Qy = clamp(Qy, 1, hs);
    Qx = clamp(floor(ws*G_T(:,:,1)), 1, ws);
    
    B_S_flat = reshape(B_S, [], 3);
    Q = sub2ind([hs ws], Qy, Qx);
    B_T_flat = B_S_flat(Q, :);
    B_T = reshape(B_T_flat, ht, wt, 3);
end


function B_T = base_transfer_slow(B_S, G_S, G_T)
    [hs, ws, ~] = size(G_S); 
    [ht, wt, ~] = size(G_T);
    
    B_T = zeros(ht, wt, 3);
    
    Qy = floor(hs*(1.0 - G_T(:,:,2)));
    Qy = clamp(Qy, 1, hs);
    Qx = clamp(floor(ws*G_T(:,:,1)), 1, ws);
    
    for py=1:ht
        for px=1:wt
            qy = Qy(py,px);
            qx = Qx(py,px);
            
            B_T(py, px, :) = B_S(qy,qx,:);
        end
    end
end
