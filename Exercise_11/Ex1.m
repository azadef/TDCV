clc;
clear;
close all;

%% Part 1
scales = 2 .^ (7:-1:0);
scales = 1;
I = imread('lena.gif');
%I_gray = rgb2gray(I);

figure;
imagesc(I);
rect = getrect();
T = I(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3));
disp([rect(1),rect(2)]);
%I_sampled = I(1:2:size(I_sampled,1),1:2:size(I_sampled,2));
%T_sampled = T;
nnc_score = [];
ssd_score = [];

xstart = 1;
ystart = 1;
for i = scales
    disp(i);
    ssd_score = zeros(size(I));
    ncc_score = zeros(size(I));
    for z=1:size(I,3)
        I_sampled = I(1:i:size(I,1),1:i:size(I,2),z);
        T_sampled = T(1:i:size(T,1),1:i:size(T,2),z);

        [xsize , ysize ] = size(I_sampled);
        [txsize , tysize ] = size(T_sampled);
        for x=xstart:xsize-txsize
            for y=ystart:ysize-tysize
                %nnc_score =[nnc_score [NCC(I_sampled,T_sampled,x,y);x;y]];
                %ssd_score = [ssd_score [SSD(I_sampled,T_sampled,x,y);x;y]];
                ssd_score(y, x , z) = SSD(I_sampled,T_sampled,x,y);
                ncc_score(y, x , z) = NCC(I_sampled,T_sampled,x,y);
            end
        end
    end
    ssd_score = mean(ssd_score,3);
    ncc_score = mean(ncc_score,3);
    ssdmax=find(ssd_score(:)==max(ssd_score(:)));
    [xmax,ymax]=ind2sub(size(ssd_score),ssdmax);
    disp([xmax,ymax]);
end