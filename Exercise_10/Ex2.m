clc;
clear;

%%Part 2
%corners = [502, 305, 55,40];    %x y w h
corners = [502, 305, 555,345];    %xtl ytl xbr ybr
w = corners(3)-corners(1);
h = corners(4)-corners(2);

img_dir = dir('sequence/*.jpeg');
out_dir = 'results/';
nFrames = size(img_dir,1);

images = cell(nFrames,1);
for i=1:nFrames
   %images{i} = single(rgb2gray(imread(['seq/' img_dir(i).name])))/255;
   images{i} = single(imread(['sequence/' img_dir(i).name]))/255;
end

patch = images{1}(corners(2):corners(4)-1,corners(1):corners(3)-1,:);
hist = colorHist(patch);


xc0 = zeros(1,nFrames);
yc0 = zeros(1,nFrames);
h2 = round(h/2);
w2 = round(w/2);

xc0(1) = corners(1) + w2;
yc0(1) = corners(2) + h2;

for j=2:nFrames
    %patch = images{j}(corners(2):corners(4)-1,corners(1):corners(3)-1,:);
    
    xc0(j) = xc0(j-1);
    yc0(j) = yc0(j-1);
    for k=1:20
        
        patch = images{j}(yc0(j)-h2:yc0(j)+h2,xc0(j)-w2:xc0(j)+w2,:);
        
        map = probMap(patch, hist);
        norm = sum(sum(map));
        
        [xg, yg] = meshgrid(xc0(j)-w2:xc0(j)+w2,yc0(j)-h2:yc0(j)+h2);
        
        xc = round(sum(sum(xg.*map)) / norm);
        yc = round(sum(sum(yg.*map)) / norm);
        
        if abs(xc0(j) - xc) < 2 || abs(yc0(j) - yc) < 2
            xc0(j) = xc;
            yc0(j) = yc;
            break;
        else
            xc0(j) = xc;
            yc0(j) = yc;
        end
    end
    rect = [xc0(j)-w2,yc0(j)-h2,w,h];
    hist = colorHist(patch);
    
    imshow(images{j})
    
    rectangle('Pos',rect,'EdgeColor','g')
    drawnow
end