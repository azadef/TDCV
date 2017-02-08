clc;
clear;
close all;

%% Part 1
scales = 2 .^ (5:-1:0);
%scales = 1;
%I = imread('lena.gif');
I = imread('monalisa.jpg');
%I = rgb2gray(I);

figure;
imagesc(I); hold on; colormap gray;

I = double(I);
rect = round(getrect());
T = I(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:);
disp(['First pos: ' num2str(rect(1)) ',' num2str(rect(2))]);
%I_sampled = I(1:2:size(I_sampled,1),1:2:size(I_sampled,2));
%T_sampled = T;

ssd_xstart = 1;
ssd_ystart = 1;
ncc_xstart = 1;
ncc_ystart = 1;
for i = scales
    disp(['Scale: ' num2str(i)]);
    
    %ssd_score = zeros(round(size(I,1)/i)-round(size(T,1)/i)-ssd_xstart, ...
    %    round(size(I,2)/i)-round(size(T,2)/i)-ssd_ystart,size(I,3));
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
%     cols = sum(ssd_score,1);
%     rows = sum(ssd_score,2);
%     ssd_score(:,~cols) = [];
%     ssd_score(~rows,:) = [];
    ncc_score = mean(ncc_score,3);
    ssdmax=find(ssd_score(:)==min(nonzeros(ssd_score(:))));
    nccmax=find(ncc_score(:)==max(ncc_score(:)));
    [ssd_xmax,ssd_ymax]=ind2sub(size(ssd_score),ssdmax);
    [ncc_xmax,ncc_ymax]=ind2sub(size(ncc_score),nccmax);
    
    ssd_xstart = min(ssd_xmax);
    ssd_ystart = min(ssd_ymax);
    ncc_xstart = min(ncc_xmax);
    ncc_ystart = min(ncc_ymax);
    disp(['SSD: ' num2str(ssd_xstart) ' , ' num2str(ssd_ystart)]);
    disp(['NCC: ' num2str(ncc_xstart) ' , ' num2str(ncc_ystart)]);
    
end

ssd_rect = [ssd_xstart+1,ssd_ystart+1, rect(3),rect(4)];
ncc_rect = [ncc_xstart+2,ncc_ystart+2, rect(3),rect(4)];
rectangle('Pos', ssd_rect,'EdgeColor','g');
rectangle('Pos', ncc_rect,'EdgeColor','r');