close all;
clc;

run('D:\MS Informatics\3rd Semester\Tracking and Detection\Exercises\3rd Exercise/VLFEATROOT/toolbox/vl_setup');
run('D:\MS Informatics\3rd Semester\Tracking and Detection\Exercises\3rd Exercise/matconvnet/matlab/vl_setupnn');

Ia_2 = single(imread('scene.pgm'))/255;
Ib_2 = single(imread('box.pgm'))/255;

% Ia_2 = single(rgb2gray('scene.pgm')) ;
% Ib_2 = single(rgb2gray('box.pgm')) ;

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
showMatchedFeatures(Ia_2,Ib_2, fa(1:2,matches(1,:))' ,fb(1:2,matches(2,:))','montage');
title('all matched features')

% [tform, inlier1, inlier2] = estimateGeometricTransform(fa(1:2,matches(1,:))',fb(1:2,matches(2,:))','similarity');
% figure(4);
% showMatchedFeatures(Ia_2,Ib_2,inlier1,inlier2,'montage');

[H, mBox, mScene] = ransac(mBox, mScene, 180, 25, 20000)
figure(4);
showMatchedFeatures(Ia_2, Ib_2, mBox, mBox, 'montage');
title('consensus features')

% pnts1 = [10 20 3 15 106 16;17 18 19 20 120 34;1 1 1 1 1 1];
% pnts2 = [17 18 19 20 120 34;10 20 3 15 106 16;1 1 1 1 1 1];
% d = DLT(pnts1,pnts2);
% disp(d);

