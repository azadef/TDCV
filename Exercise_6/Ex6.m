%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Exercise 1

close all;
clc;

%run('D:\MS Informatics\3rd Semester\Tracking and Detection\Exercises\3rd Exercise/VLFEATROOT/toolbox/vl_setup');
run('vlfeat-0.9.20/toolbox/vl_setup');

Ia_2 = single(rgb2gray(imread('img_sequence/0000.png')))/255;
Ib_2 = single(rgb2gray(imread('img_sequence/0000.png')))/255;

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

corners = [103,75;
           550,75;
           105,385;
           553,385];

min_x = min(corners(:,1));
max_x = max(corners(:,1));
min_y = min(corners(:,2));
max_y = max(corners(:,2));
valid = fa(1,:) > min_x & fa(1,:) <= max_x & ...
             fa(2,:) > min_y & fa(2,:) <= max_y;
fa_2 = fa(:, valid);
da_2 = da(:, valid);
m = [fa_2(1:2, :); ones(1,size(fa_2, 2))];
%m = padarray(matches, [1 0], 1, 'post');
A = [472.3,0.64,329.0; 0,471.0,268.3; 0,0,1];
Ainv = inv(A);
Mi0 = A \ m;
%Mi0 = Mi0';
Mi0 = [Mi0; ones(1,size(fa_2, 2))];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img_dir = dir('img_sequence/*.png');
out_dir = 'results/';
n = size(img_dir,1);
%n = 2;
images = cell(n,1);
for i=1:n
   images{i} = single(rgb2gray(imread(['img_sequence/' img_dir(i).name]))); 
end

out_result = cell(n,1);
m0 = cell(n,1);
mT = cell(n,1);
%[fa, da] = vl_sift(images{1}) ;
for i=1:n
    [fb, db] = vl_sift(images{i}) ;
    % This should be replaced by the points found in part1 
    [matches, scores] = vl_ubcmatch(da_2, db) ;
    m0{i} = fa_2(1:2,matches(1,:))' ;
    mT{i} = fb(1:2,matches(2,:))' ;
    %[H, m0{i}, mT{i}] = ransac(m0{i}, mT{i}, 80, 25, 20000);
    [H, m0{i}, mT{i}] = estimateGeometricTransform(...
        m0{i}, ...
        mT{i}, 'affine', ...
        'MaxNumTrials', 4000, ...
        'MaxDistance', 4);
    out_result{i} = showMatchedFeatures(images{1}, images{i}, m0{i}, mT{i}, 'montage');
    saveas(gcf,[out_dir img_dir(i).name]);
end

Rt = zeros(1,3,n);
% initial rotation is all zeros
Rt(:,:,1) = [0, 0, 0];    

% initial translation is all zeros
Tt = zeros(1,3,45);
Tt(:,:,1) = [0, 0, 0];

% camera in world coordinates
Ct = zeros(3,45);
Ct(:,1) = zeros(3,1);

% T= zeros(3, 1);
% R = [1,1,1;1,1,1;1,1,1];
% X = horzcat(R,T);

N= 44; %Number of image frames except the first

options = optimset('MaxFunEvals', 1e6, 'MaxIter', 1e4, 'TolX', 1e-14, 'TolFun', 1);

for j = 2:n+1  
%   X = horzcat(R,T);
  X = [Rt(:,:,j-1),Tt(:,:,j-1)];
  
  m0{j-1} = [m0{j-1}(:,1:2), ones(size(m0{j-1},1),1)];
  mT{j-1} = [mT{j-1}(:,1:2), ones(size(mT{j-1},1),1)];
  mT{j-1} = mT{j-1}';
  
  M0 = m0{j-1}';
%   M0 = vertcat(M0, ones(1,size(M0,2)));
  M0 = A\M0;
  M0 = vertcat(M0, ones(1,size(M0,2)));
  
  foo = @(X) Energy(X(1:3), X(4:end), A, M0, mT{j-1});
  fprintf('Frame %02d', j-1);
  [X, e] = fminsearch(foo, X, options);
  fprintf('\t energy = %02f\n', e);


   estimated_Angles = X(1:3);
   Rt(:,:,j-1) = estimated_Angles;
   estimatedR = rotation_matrix(estimated_Angles);  
   estimatedT = X(4:end);        
    
    Tt(:,:,j-1) = estimatedT;
    Ct(:,j-1) = -estimatedR'*estimatedT';
end

%% draw our estimated camera-positions
figure('Name', 'Estimated camera coordinates', 'NumberTitle', 'Off');
plot3(Ct(1,:), Ct(2,:), Ct(3,:), 'bx-');
hold on;
text(Ct(1,:),Ct(2,:),Ct(3,:),num2str((0:45-1)'));
plot3(0,0,0,'or', 'MarkerSize', 12);
grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');