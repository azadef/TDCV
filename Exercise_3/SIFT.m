Ia = imread('shell.jpg') ;
Ib = imread('test_shell2.jpg') ;
% Ia = imread('pot.jpg') ;
% Ib = imread('test_pot2.jpg') ;
sb = size(Ib); 

Ia_2 = single(rgb2gray(Ia)) ;
Ib_2 = single(rgb2gray(Ib)) ;

%perm = randperm(size(f,2)) ;
%sel = perm(1:50) ;
[fa, da] = vl_sift(Ia_2) ;
[fb, db] = vl_sift(Ib_2) ;
[matches, scores] = vl_ubcmatch(da, db) ;

Ia(sb(1),1)=0;
figure(2) ; clf ;
% imagesc(cat(2, Ia, Ib)) ;
showMatchedFeatures(Ia,Ib, fa(1:2,matches(1,:))' ,fb(1:2,matches(2,:))','montage');
% xa = fa(1,matches(1,:)) ;
% xb = fb(1,matches(2,:)) + size(Ia,2) ;
% ya = fa(2,matches(1,:)) ;
% yb = fb(2,matches(2,:)) ;
% 
% hold on ;
% h = line([xa ; xb], [ya ; yb]) ;
% set(h,'linewidth', 1, 'color', 'b') ;
% 
% vl_plotframe(fa(:,matches(1,:))) ;
% fb_2 = fb;
% fb_2(1,:) = fb(1,:) + size(Ia,2) ;
% vl_plotframe(fb_2(:,matches(2,:))) ;
% axis image off ;

[tform, inlier1, inlier2] = estimateGeometricTransform(fa(1:2,matches(1,:))',fb(1:2,matches(2,:))','similarity');
% figure(3) ; clf ;
% imagesc(cat(2, Ia, Ib)) ;
% 
% xa = inlier1(:,1) ;
% xb = inlier2(:,1) ;
% ya = inlier1(:,2) ;
% yb = inlier2(:,2) ;
figure(3);
showMatchedFeatures(Ia,Ib,inlier1,inlier2,'montage');
