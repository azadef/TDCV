function [corners] = harris_det(I,n, s0, k, alpha, t)

% Mask for derivative
dx = [-1 0 1; -1 0 1; -1 0 1];
dy = dx';

Idx = conv2(I, dx, 'same');
Idy = conv2(I, dy, 'same');

% from Mikolajczyk and Schmid (2004), page 2, right side, above
% characterstic scale 
sigI = k^n * s0;
sigD = 0.7 * sigI;

% Gaussian smoothing    
gD = G_2D(sigD);
Ix = conv2(Idx, gD, 'same');
Iy = conv2(Idy, gD, 'same');

% 2. 2nd moment matrix
gI = G_2D(sigI);
Ixx = sigD^2 * conv2(Ix .* Ix, gI, 'same');
Ixy = sigD^2 * conv2(Ix .* Iy, gI, 'same');
Iyy = sigD^2 * conv2(Iy .* Iy, gI, 'same');

detM = Ixx .* Iyy - Ixy.^2;
traceM = Ixx + Iyy;
R = detM - alpha * traceM.^2;

R(R<t) = 0;
corners = nms(R, 3, 3);
[y,x] = ind2sub(size(corners), find(corners>0));
corners = [y,x];
% corners = uint8(corners);
% imshow(corners);

end