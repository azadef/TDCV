close all;
clc;

%run('D:\MS Informatics\3rd Semester\Tracking and Detection\Exercises\3rd Exercise/VLFEATROOT/toolbox/vl_setup');
%run('D:\MS Informatics\3rd Semester\Tracking and Detection\Exercises\3rd Exercise/matconvnet/matlab/vl_setupnn');

% Ia_2 = single(imread('scene.pgm'))/255;
% Ib_2 = single(imread('box.pgm'))/255;
Ia_2 = single(imread('ex05/scene.pgm'))/255;
Ib_2 = single(imread('ex05/box.pgm'))/255;

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

[H, mBox, mScene] = ransac(mBox, mScene, 80, 25, 20000)
% [H, mBox, mScene] = adaptiveRansac(matched_box, matched_scene, 250)
figure(4);
showMatchedFeatures(Ia_2, Ib_2, mBox, mScene, 'montage');
title('consensus features')

[H, mBox, mScene] = adaptiveRansac(mBox, mScene, 200)
figure(5);
showMatchedFeatures(Ia_2, Ib_2, mBox, mScene, 'montage');
title('consensus features robust')
%% 
I3 = imwarp(Ib_2,projective2d(H'));
imshow(I3);
showMatchedFeatures(Ia_2, I3, mBox, mScene, 'blend');

%im1 = Ib_2;
%im2 = Ia_2;
box2 = [1  size(Ia_2,2) size(Ia_2,2)  1 ;
        1  1           size(Ia_2,1)  size(Ia_2,1) ;
        1  1           1            1 ] ;
box2_ = inv(H) * box2 ;
box2_(1,:) = box2_(1,:) ./ box2_(3,:) ;
box2_(2,:) = box2_(2,:) ./ box2_(3,:) ;
ur = min([1 box2_(1,:)]):max([size(Ib_2,2) box2_(1,:)]) ;
vr = min([1 box2_(2,:)]):max([size(Ib_2,1) box2_(2,:)]) ;

[u,v] = meshgrid(ur,vr) ;
im1_ = vl_imwbackward(im2double(Ib_2),u,v) ;

z_ = H(3,1) * u + H(3,2) * v + H(3,3) ;
u_ = (H(1,1) * u + H(1,2) * v + H(1,3)) ./ z_ ;
v_ = (H(2,1) * u + H(2,2) * v + H(2,3)) ./ z_ ;
im2_ = vl_imwbackward(im2double(Ia_2),u_,v_) ;

mass = ~isnan(im1_) + ~isnan(im2_) ;
im1_(isnan(im1_)) = 0 ;
im2_(isnan(im2_)) = 0 ;
mosaic = (im1_ + im2_) ./ mass ;

figure(6) ; clf ;
imagesc(mosaic) ; axis image off ; colormap gray;
title('Mosaic') ;
