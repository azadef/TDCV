close all;
clear;
I = imread('lena.gif');

%% -------Part 1------- %
H = [1 1 1;1 1 1;1 1 1]/9;

F = Conv(I,H,1);
figure
imagesc(F), colormap gray
title('mirror border treatment')

J = Conv(I,H,2);
figure
imagesc(J), colormap gray
title('clamp border treatment')
% -----End of Part 1-------- %

%% ------ Part 2 -------- %
%a) 2D Gaussian
%----- sigma = 1-------%
sig = 1;
mask = G_2D(sig);

tic
C_2d_1 = Conv(I,mask,1);
%C_2d_1 = conv2(I,mask);
time2d_1 = toc;

% R = imgaussfilt(I,1);

C_2d_1 = uint8(C_2d_1);

% subplot(3,2,1), imshow(I), title('Original Image');
figure
subplot(3,2,1), imshow(C_2d_1)
title('Gaussian filtered image, \sigma = 1');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% sigma = 3 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sig = 3;
mask = G_2D(sig);

tic
C_2d_3 = Conv(I,mask,1);
time2d_3 = toc;

%  C = imgaussfilt(I,3);

C_2d_3 = uint8(C_2d_3);

subplot(3,2,2), imshow(C_2d_3)
title('Gaussian filtered image, \sigma = 3');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% exercise 2 b %%%%
%%%% sigma = 1 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sig = 1;
[mask_h, mask_v] = G_1D(sig);

tic
C_1d_1 = Conv(I,mask_h,1);
Out_1 = Conv(C_1d_1,mask_v,1);
%C_1d_1 = conv2(I,mask_h);
%Out_1 = conv2(C_1d_1,mask_v);
time1d_1 = toc;

% R = imgaussfilt(I, [1,1]);

Out_1 = uint8(Out_1);

subplot(3,2,3), imshow(Out_1)
title('2x ID Image, \sigma = 1');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% exercise 2 b %%%%
%%%% sigma = 3 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sig = 3;



% mask_h = mask_h/sum(mask_h);

[mask_h, mask_v] = G_1D(sig);
% mask_v = mask_v/sum(mask_v);

% C = zeros(size(I));
tic
C_1d_3 = Conv(I,mask_h,1);
Out_3 = Conv(C_1d_3,mask_v,1);
time1d_3 = toc;

%R = imgaussfilt(I,3);

Out_3 = uint8(Out_3); 
%imshow(R)

% subplot(3,2,5), imshow(I), title('Original Image');
subplot(3,2,4), imshow(Out_3)
title('2x ID Image, \sigma = 3');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% exercise 2 b %%%%
%%%% Part 3 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assd_1 = zeros(512,512);

for i = 1:512
    for j = 1:512
        ssd_1(i,j) = (C_2d_1(i,j) - Out_1(i,j))*(C_2d_1(i,j) - Out_1(i,j));
    end
end

ssd_1 = uint8(ssd_1);
subplot(3,2,5), imshow(ssd_1)
title('Sum of squared differences, \sigma = 1');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% exercise 2 b %%%%
%%%% Part 3 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ssd_3 = zeros(512,512);

for i = 1:512
    for j = 1:512
        ssd_3(i,j) = (C_2d_3(i,j) - Out_3(i,j))*(C_2d_3(i,j) - Out_3(i,j));
    end
end

ssd_3 = uint8(ssd_3);
subplot(3,2,6), imshow(ssd_3)
title('Sum of squared differences, \sigma = 3');

fprintf('2x 1d for sigma=1 convolution done in: %f s\n', time1d_1);
fprintf('2d convolution for sigma=1 done in: %f s\n', time2d_1);

fprintf('2x 1d for sigma=3 convolution done in: %f s\n', time1d_3);
fprintf('2d convolution for sigma=3 done in: %f s\n', time2d_3);
%% ------- Part 3 ----------- %

%a)
Dx = [-1 0 1;-1 0 1;-1 0 1];
Dy = [-1 -1 -1;0 0 0;1 1 1];

I = double(I);
%b)
I_Dx = Conv(I,Dx,1);
I_Dy = Conv(I,Dy,1);
gr_magnitude = sqrt(I_Dx.*I_Dx + I_Dy.*I_Dy);
gr_orientation = atan(I_Dy./I_Dx);

figure
imshowpair(uint8(gr_magnitude),uint8(gr_orientation),'montage')
title('Gradient magnitude and Gradient Orientation')

%c)
[mask_h , mask_v] = G_1D(1);
mask_sx = Conv(mask_h,Dx,1);
I_x = Conv(I,mask_sx,1);
mask_sy = Conv(mask_v,Dy,1);
I_y = Conv(I,mask_sy,1);
gr_magnitude_smooth = sqrt(I_x.*I_x + I_y.*I_y);
gr_orientation_smooth = atan(I_y./I_x);

figure
imshowpair(uint8(gr_magnitude_smooth),uint8(gr_orientation_smooth),'montage')
title('Smoothed Gradient magnitude and Gradient Orientation')