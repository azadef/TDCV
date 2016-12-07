function [finalH, finalB, finalS] = ransac(points1, points2, t, T, N)

ptSize = size(points1, 1);
assert(size(points1, 1) == size(points2, 1));

%padding array so as to make it compatible with DLT
points1 = padarray(points1, [0 1], 1, 'post');
points2 = padarray(points2, [0 1], 1, 'post');


final_consensus = [];
cSize = 0;
H = cell(N,1);
%ok = cell(N,1);
%score = cell(N,1);
for n = 1:N
%     sampleSize = 4 + (ptSize - 4).*rand(100,1);
    sampleSize = randi([4 ptSize]);
    sample = randsample(ptSize, sampleSize);
    
    sample1 = points1(sample, :);
    sample2 = points2(sample, :);
    
    %H = DLT_check(sample1, sample2);
    H = DLT(sample1,sample2);
    %distance calculation
    % Calculate, in both directions, the transfered points    
%     Hp1    = H*sample1';
%     invHp2 = H\sample2';
%     
%     % Normalise so that the homogeneous scale parameter for all coordinates
%     % is 1.
%     
%     p1     = normalize(sample1);
%     p2     = normalize(sample2);     
%     Hp1    = normalize(Hp1);
%     invHp2 = normalize(invHp2); 
%     d2 = sum((p1-invHp2).^2)  + sum((p2-Hp1).^2);
    
%     X2 = sample2';
%     X2_ = H*sample1' ;
%     du = X2_(1,:)./X2_(3,:) - X2(1,:)./X2(3,:) ;
%     dv = X2_(2,:)./X2_(3,:) - X2(2,:)./X2(3,:) ;
%     d2 = (du.*du + dv.*dv);
%     d2 = sqrt(d2);
    
    %	Project Point1 to Point3 using H, then calcultate the distances between
    %	Point2 and Point3
%     p3 = (points1)*H';
%     p3 = p3(:,1:2);
%     p2 = points2(:,1:2);
%     d2 = p2 - p3;
%     d2 = sum(d2.^2, 2);
    

%compute putatitve correspondences
S1p = points1*H';
S1pn = S1p./repmat(S1p(:,3),1,3);

%compute distances
ds = sqrt(sum(((points2-S1pn).^2),2));

dts = ds<t;
consensus = dts;
    
%     d2 = distance(points1, points2, H);
%     mean(sqrt(d2))
% %     consensusLog = d2 < t;
%     consensus = d2 < t; 
    countInliers = sum(consensus);
    
    %If the size of Si (the number of inliers) is greater than some threshold T, re-estimate
    %the model using all the points in Si and terminate.
    if countInliers > T
        [finalH, finalB, finalS] = calculate_final(points1, points2, consensus);
        return
    end
    
    %d) If the size of Si is less than T, select a new subset and repeat the above.
    if cSize < countInliers
           final_consensus = consensus;
    end
       
end
    %After N trials the largest consensus set Si is selected, and the model is re-estimated
    %using all the points in the subset Si.
    [finalH, finalB, finalS] = calculate_final(points1, points2, final_consensus);
    

end

%calculate final implementation
function [H, B, S] = calculate_final(points1, points2, final_consensus)

    B = points1(final_consensus, :);
    S = points2(final_consensus, :);
    %H = DLT_check(B, S);
    H = DLT(B, S);
    
    B = B(:,1:2);

    S = S(:,1:2);

end
