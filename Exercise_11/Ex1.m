clc;
clear;
close all;

%% Part 1
scales = 2 .^ (4:-1:0);
%scales = 1;
%I = double(imread('lena.gif'));
I = imread('monalisa.jpg');
I = rgb2gray(I);

figure;
imagesc(I); hold on; colormap gray;

I = double(I);
rect = round(getrect());
T = I(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:);
disp([rect(1),rect(2)]);
%I_sampled = I(1:2:size(I_sampled,1),1:2:size(I_sampled,2));
%T_sampled = T;

ssd_xstart = 1;
ssd_ystart = 1;
ncc_xstart = 1;
ncc_ystart = 1;
for i = scales
    disp(i);
    ssd_score = zeros(size(I));
    ncc_score = zeros(size(I));
    for z=1:size(I,3)
        I_sampled = I(1:i:size(I,1),1:i:size(I,2),z);
        T_sampled = T(1:i:size(T,1),1:i:size(T,2),z);

        [xsize , ysize ] = size(I_sampled);
        [txsize , tysize ] = size(T_sampled);
        for x=ssd_xstart:xsize-txsize
            for y=ssd_ystart:ysize-tysize
                ssd_score(y, x , z) = SSD(I_sampled,T_sampled,x,y);
            end
        end
        for x=ncc_xstart:xsize-txsize
            for y=ncc_ystart:ysize-tysize
                ncc_score(y, x , z) = NCC(I_sampled,T_sampled,x,y);
            end
        end
    end
    ssd_score = mean(ssd_score,3);
    ncc_score = mean(ncc_score,3);
    ssdmax=find(ssd_score(:)==max(ssd_score(:)));
    nccmax=find(ncc_score(:)==max(ncc_score(:)));
    [ssd_xmax,ssd_ymax]=ind2sub(size(ssd_score),ssdmax);
    [ncc_xmax,ncc_ymax]=ind2sub(size(ncc_score),nccmax);
    
    ssd_xstart = min(ssd_xmax);
    ssd_ystart = min(ssd_ymax);
    ncc_xstart = min(ncc_xmax);
    ncc_ystart = min(ncc_ymax);
    disp([ssd_xstart,ssd_ystart]);
    disp([ncc_xstart,ncc_ystart]);
    
end

ssd_rect = [ssd_xstart,ssd_ystart, rect(3),rect(4)];
ncc_rect = [ncc_xstart,ncc_xstart, rect(3),rect(4)];
rectangle('Pos', ssd_rect,'EdgeColor','g');
rectangle('Pos', ncc_rect,'EdgeColor','r');