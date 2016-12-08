close all;
clc;

img_dir = dir('img_sequence/*.png');
out_dir = 'results/';
n = size(img_dir,1);
%n = 3;
images = cell(n,1);
for i=1:n
   images{i} = single(rgb2gray(imread(['img_sequence/' img_dir(i).name]))); 
end

out_result = cell(n,1);
m0 = cell(n,1);
mT = cell(n,1);
[fa, da] = vl_sift(images{1}) ;
for i=1:n
    [fb, db] = vl_sift(images{i}) ;
    % This should be replaced by the points found in part1 
    [matches, scores] = vl_ubcmatch(da, db) ;
    m0{i} = fa(1:2,matches(1,:))' ;
    mT{i} = fb(1:2,matches(2,:))' ;
    [H, m0{i}, mT{i}] = ransac(m0{i}, mT{i}, 50, 25, 20000);
    out_result{i} = showMatchedFeatures(images{1}, images{i}, m0{i}, mT{i}, 'montage');
    saveas(gcf,[out_dir img_dir(i).name]);
end