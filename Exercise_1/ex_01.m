close all;
clc;

%-------Part 1-------%
H = [1 1 1;1 1 1;1 1 1]/9;
I = imread('lena.gif');

%J = Conv(I,H,2);
%F = Conv(I,H,1);
%J = uint8(J);
%imshowpair(F,J,'montage');
%-------Part 3-------%
%a)
Dx = [-1 0 1;-1 0 1;-1 0 1];
Dy = [-1 -1 -1;0 0 0;1 1 1];

I = double(I);
%b)
I_Dx = Conv(I,Dx,1);
I_Dy = Conv(I,Dy,1);
gr_magnitude = sqrt(I_Dx.*I_Dx + I_Dy.*I_Dy);
gr_orientation = atan(I_Dy./I_Dx);
imshowpair(uint8(gr_magnitude),uint8(gr_orientation),'montage');
%c)
