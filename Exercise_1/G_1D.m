function [mask_h, mask_v] = G_1D(sig)
    d = 2.0 * sig * sig;

    % mask_h = [-1,0,1];
    % mask_v = [-1;0;1];

    n = 3 * sig;
    indices = -floor(n/2):floor(n/2);
    %x = [-1,0,1];
    %y = [-1;0;1];
    x = indices;
    y = x';
    c = sqrt(d * pi);
    a = (x .* x);
    mask_h = exp(-a/d)/c;
    %mask_h = mask_h/sqrt(d * pi);

    b = (y .* y);
    mask_v = exp(-b/d)/c;
    %mask_v = mask_v/sqrt(d * pi);
end