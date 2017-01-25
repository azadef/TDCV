clear;
clc;
%% Part 1
img_dir = dir('seq/*.pgm');
out_dir = 'results/';
nFrames = size(img_dir,1);
% corners = [120 220;   %Ex 6 dataset
%            220 220;
%            220 320;
%            120 320];
corners = [205 220; %New dataset
           305 220;
           305 320;
           205 320];
       
updateNum = 10;
gridSpace = 5;

images = cell(nFrames,1);
for i=1:nFrames
   %images{i} = single(rgb2gray(imread(['seq/' img_dir(i).name])))/255;
   images{i} = single(imread(['seq/' img_dir(i).name]))/255;
end

A = cell(updateNum,1);
[gridX, gridY] = meshgrid(min(corners(:,1)):gridSpace:max(corners(:,1)),...
    min(corners(:,2)):gridSpace:max(corners(:,2)));
grid = [gridX(:), gridY(:)];

m = 10*size(grid,1);
%m = 10000;

intensities = images{1}(sub2ind(size(images{1}), ...
                grid(:,2),grid(:,1)));
sample = normalize(intensities);

P = zeros(8,m);       % corner displacements
I = zeros(size(grid,1),m);  % differences

for i=1:updateNum
    disp(['********** range: ' num2str((updateNum -i +1)*[-3,3]) ' **********']);
    updateMatrice = [-3,3] * (updateNum -i +1);
    
    for j = 1:m
        hasNaN = true; 
        while hasNaN
            displacement =  randi(updateMatrice,size(corners));
            H = estimateGeometricTransform(corners, corners + displacement, 'projective');
            
            warped_grid = padarray(grid, [0 1], 1, 'post');
            warped_grid = warped_grid * H.T;
            warped_grid = warped_grid(:, 1:2) ./ repmat(warped_grid(:, 3), [1 2]);
            
            warped_intensity = interp2(images{1}, warped_grid(:, 1), ...
                warped_grid(:, 2), 'linear');
             
            %warped_intensity = images{1}(sub2ind(size(images{1}), ...
            %    uint8(warped_grid(:,1)),uint8(warped_grid(:,2))));

            warped_intensity = normalize(warped_intensity) ...
                       + 0.1 * randn(size(warped_intensity));
            P(:,j) = displacement(:);
            I(:,j) = warped_intensity - sample;
            
            hasNaN = nnz(isnan(warped_intensity)) > 0;
        end
    end
    A{i} =  P * I' * inv(I * I');
end
A2 = zeros([size(A{1}) numel(A)]);
for i = 1:numel(A)
    A2(:, :, i) = A{i};
end
save('A2.mat', 'A2');
%save('A.mat','A');