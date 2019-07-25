function y = clamp(x, a, b)
    % CLAMP clip x in the range [a b]
    %
    % Inputs:
    % - x: float or matrix
    % - a: float. a of [a b]
    % - b: float. b of [a b]
    %
    % Outputs:
    % - y: clamped value of x.
    %
    y = max(min(x, b), a);
end