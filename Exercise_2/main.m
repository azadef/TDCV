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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Harris

n = 0;
s0 = 1.5;
k = 1.2;
alpha = 0.04;
t = 0.1;

img1 = 'test.pgm';
img2= 'house.tif';
img3 = 'sample2.jpg';
img4 = 'checkerboard_tunnel.png';

% I=double(rgb2gray(imread(img3)))/255.0;
I=double(imread(img3))/255.0;
pt=harris_det(I,n, s0, k, alpha, t);
[x, y] = ind2sub(size(pt), find(pt>0));
imagesc(I), colormap gray, axis equal tight off;
% imshow(I);
hold on;
plot(x,y,'r.','MarkerSize',10)
