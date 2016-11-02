
I = imread('lena.gif');

% sig = str2double(input('Enter sigma : ','s'));
% if isnan(sig) || fix(sig) ~= sig
%   disp('Please enter an integer')
% else
%     sig
%     disp('is the Sigma');
% end

sig = 1;
d = 2.0 * sig * sig;

mask = zeros(3*double(sig));

n = 3 * sig;
indices = -floor(n/2):floor(n/2);
[x,y] = meshgrid(indices, indices);

a = ((x .* x) + (y .* y));
mask = exp(-a/d);

mask = mask/(2 * sig * sig * pi);

% C = zeros(size(I));
tic
C_2d_1 = Conv(I,mask,1);
time2d_1 = toc;

% R = imgaussfilt(I,1);

C_2d_1 = uint8(C_2d_1);
% imshow(C);

% subplot(3,2,1), imshow(I), title('Original Image');
subplot(3,2,1), imshow(C_2d_1)
title('Gaussian filtered image, \sigma = 1');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% sigma = 3 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sig = 3;
d = 2.0 * sig * sig;

sum = 0.0;

mask = zeros(3*double(sig));

n = 3 * sig;
indices = -floor(n/2):floor(n/2);
[x,y] = meshgrid(indices, indices);

a = ((x .* x) + (y .* y));
mask = exp(-a/d);

mask = mask/(2 * sig * sig * pi);

% C = zeros(size(I));
tic
C_2d_3 = Conv(I,mask,1);
time2d_3 = toc;

%  C = imgaussfilt(I,3);

C_2d_3 = uint8(C_2d_3);
% imshow(C);

% subplot(3,2,3), imshow(I), title('Original Image');
subplot(3,2,2), imshow(C_2d_3)
title('Gaussian filtered image, \sigma = 3');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% exercise 2 b %%%%
%%%% sigma = 1 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sig = 1;
d = 2.0 * sig * sig;

sum = 0.0;

% mask_h = [-1,0,1];
% mask_v = [-1;0;1];

% n = 3 * sig;
% indices = -floor(n/2):floor(n/2);
x = [-1,0,1];
y = [-1;0;1];

mask_h = exp(-1/(2*sig*sig) * (x.*x));
mask_h = mask_h/sqrt(2 * sig * sig * pi);

mask_v = exp(-1/(2*sig*sig) * (y.*y));
mask_v = mask_v/sqrt(2 * sig * sig * pi);


% C = zeros(size(I));
tic
C_1d_1 = Conv(I,mask_h,1);
Out_1 = Conv(C_1d_1,mask_v,1);
time1d_1 = toc;

% R = imgaussfilt(I, [1,1]);

Out_1 = uint8(Out_1);
% imshow(C);

% subplot(3,2,5), imshow(I), title('Original Image');
subplot(3,2,3), imshow(Out_1)
title('2x ID Image, \sigma = 1');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% exercise 2 b %%%%
%%%% sigma = 3 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sig = 3;
d = 2.0 .* sig .* sig;

sum = 0.0;

% mask_h = [-1,0,1];
% mask_v = [-1;0;1];

% n = 3 * sig;
% indices = -floor(n/2):floor(n/2);
x = [-4,-3,-2,-1,0,1,2,3,4];
y = [-4;-3;-2;-1;0;1;2;3;4];

a = (x .* x);
mask_h = exp(-a/d);
mask_h = mask_h/sqrt(d * pi);
% mask_h = mask_h/sum(mask_h);

b = (y .* y);
mask_v = exp(-b/d);
mask_v = mask_v/sqrt(d * pi);
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