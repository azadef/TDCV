function [corners] = harris_det(I,n, s0, k, alpha, t)

% Mask for derivative
dx = [-1 0 1; -1 0 1; -1 0 1];
dy = dx';

Idx = Conv(I, dx, 1);
Idy = Conv(I, dy, 1);

% from Mikolajczyk and Schmid (2004), page 2, right side, above
% characterstic scale 
sigI = k^n * s0;
sigD = 0.7 * sigI;

% Gaussian smoothing    
gD = G_2D(sigD);
Ix = Conv(Idx, gD, 1);
Iy = Conv(Idy, gD, 1);

% 2. 2nd moment matrix
gI = G_2D(sigI);
Ixx = sigD^2 * Conv(Ix .* Ix, gI, 1);
Ixy = sigD^2 * Conv(Ix .* Iy, gI, 1);
Iyy = sigD^2 * Conv(Iy .* Iy, gI, 1);

detM = Ixx .* Iyy - Ixy.^2;
traceM = Ixx + Iyy;
R = detM - alpha * traceM.^2;

R(find(R<t)) = 0;
corners = nms(R, 3, 3);

% corners = uint8(corners);
% imshow(corners);

end