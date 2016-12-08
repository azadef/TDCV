%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Exercise 1

close all;
clc;

run('D:\MS Informatics\3rd Semester\Tracking and Detection\Exercises\3rd Exercise/VLFEATROOT/toolbox/vl_setup');

Ia_2 = single(rgb2gray(imread('img_sequence/0026.png')))/255;
Ib_2 = single(rgb2gray(imread('img_sequence/0026.png')))/255;

[fa, da] = vl_sift(Ia_2) ;
[fb, db] = vl_sift(Ib_2) ;
[matches, scores] = vl_ubcmatch(da, db) ;

figure(1);
imshow(Ia_2);
perm1 = randperm(size(fa,2)) ;
sel1 = perm1(1:50) ;
h1 = vl_plotframe(fa(:,sel1)) ;
set(h1,'color','y','linewidth',2) ;
h3 = vl_plotsiftdescriptor(da(:,sel1),fa(:,sel1)) ;
set(h3,'color','g') ;

figure(2);
imshow(Ib_2);
perm2 = randperm(size(fb,2)) ;
sel2 = perm2(1:50) ;
h2 = vl_plotframe(fb(:,sel2)) ;
set(h2,'color','y','linewidth',2) ;
h4 = vl_plotsiftdescriptor(db(:,sel2),fb(:,sel2)) ;
set(h4,'color','g') ;

% Ia_2(sb(1),1)=0;
figure(3) ; clf ;
% imagesc(cat(2, Ia, Ib)) ;
mBox = fa(1:2,matches(1,:))' ;
mScene = fb(1:2,matches(2,:))' ;
showMatchedFeatures(Ia_2,Ia_2, fa(1:2,matches(1,:))' ,fb(1:2,matches(2,:))','montage');
title('all matched features')


m = padarray(matches, [1 0], 1, 'post');
A = [472.3,0.64,329.0; 0,471.0,268.3; 0,0,1];
Ainv = inv(A);
Mi0 = A \ m;
Mi0 = Mi0';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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