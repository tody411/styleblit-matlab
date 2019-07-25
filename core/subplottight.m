function h = subplottight(n,m,i,margin)
    % SUBPLOTTIGHT Tight layout for subplot.
    %
    % Inputs:
    % - n: number of grid rows
    % - m: number of grid columns
    % - i: grid positio for nex axes
    % - margin: margin space between plots
    % 
    if nargin < 4
        margin=0;
    end
    
    [c,r] = ind2sub([m n], i);
    ax = subplot('Position', [(c-1+margin)/m, 1-(r+margin)/n, (1-2*margin)/m, (1-2*margin)/n]);
    if(nargout > 0)
      h = ax;
    end
end