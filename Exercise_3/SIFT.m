Ia = imread('shell.jpg') ;
Ib = imread('test_shell1.jpg') ;
% Ia = imread('pot.jpg') ;
% Ib = imread('test_pot1.jpg') ;
sb = size(Ib); 

Ia_2 = single(rgb2gray(Ia)) ;
Ib_2 = single(rgb2gray(Ib)) ;

[fa, da] = vl_sift(Ia_2) ;
[fb, db] = vl_sift(Ib_2) ;
[matches, scores] = vl_ubcmatch(da, db) ;

figure(1);
imshow(Ia);
perm1 = randperm(size(fa,2)) ;
sel1 = perm1(1:50) ;
h1 = vl_plotframe(fa(:,sel1)) ;
set(h1,'color','y','linewidth',2) ;
h3 = vl_plotsiftdescriptor(da(:,sel1),fa(:,sel1)) ;
set(h3,'color','g') ;

figure(2);
imshow(Ib);
perm2 = randperm(size(fb,2)) ;
sel2 = perm2(1:50) ;
h2 = vl_plotframe(fb(:,sel2)) ;
set(h2,'color','y','linewidth',2) ;
h4 = vl_plotsiftdescriptor(db(:,sel2),fb(:,sel2)) ;
set(h4,'color','g') ;

Ia(sb(1),1)=0;
figure(3) ; clf ;
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

figure(4);
showMatchedFeatures(Ia,Ib,inlier1,inlier2,'montage');
%% Part 4 - Drawing the bounding box
x_c = mean(inlier2(:,1));
y_c = mean(inlier2(:,2));
bb_l = max(inlier2(:,2)) - min(inlier2(:,2)) + 80;
bb_w = max(inlier2(:,1)) - min(inlier2(:,1)) + 80;
figure(5);
hold on;
imshow(Ib);
rectangle('Position', [x_c-bb_w/2 y_c-bb_l/2 bb_w bb_l],'EdgeColor','r',...
    'LineWidth',3);
