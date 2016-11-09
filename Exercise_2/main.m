close all;
clear;
I = imread('checkerboard_tunnel.png');
%I = imread('sample2.jpg');
%I = rgb2gray(I);
I_d = double(I);

n = 5;
s0 = 1.5;
k = 1.2;
alpha = 0.06;
th = 1500;
tl = 10;

points = Harris_Laplace(I_d,n,s0,k,alpha, th, tl);

figure;
imagesc(I);
axis equal tight off, colormap(gray);
hold on;

for i=1:size(points,1)
   plot(points(i,2),points(i,1),'yo','MarkerSize',points(i,3)^2); 
end