function [mask] = G_2D(sig)
    d = 2.0 * sig * sig;

    %mask = zeros(3*double(sig));

    n = 3 * sig;
    indices = -floor(n/2):floor(n/2);
    [x,y] = meshgrid(indices, indices);
    a = ((x .* x) + (y .* y));
    mask = exp(-a/d) / (d*pi);

    %mask = mask/(d * pi);
end