function [finalH, p1, p2] = ransac(points1, points2, t, T, N)

assert(size(points1, 1) == size(points2, 1));

%padding array so as to make it compatible with DLT
points1 = padarray(points1, [0 1], 1, 'post');
points1 = padarray(points1, [0 1], 1, 'post');

ptSize = size(points1, 1);
final_consensus = [];
cSize = 0;

for n = 1:N
%     sampleSize = 4 + (ptSize - 4).*rand(100,1);
    sampleSize = randi([4 ptSize]);
    sample = randsample(ptSize, sampleSize);
    
    sample1 = points1(sample, :);
    sample2 = points2(sample, :);
    
    H = DLT(sample1', sample2');
    
    %distance calculation
    % Calculate, in both directions, the transfered points    
    Hp1    = H*points1;
    invHp2 = H\points2;
    
    % Normalise so that the homogeneous scale parameter for all coordinates
    % is 1.
    
    p1     = normalize(points1);
    p2     = normalize(points2);     
    Hp1    = normalize(Hp1);
    invHp2 = normalize(invHp2); 
    
    d2 = sum((p1-invHp2).^2)  + sum((p2-Hp1).^2);
    consensus = find(abs(d2) < t); 
    countInliers = size(consensus);
    
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
       
    %After N trials the largest consensus set Si is selected, and the model is re-estimated
    %using all the points in the subset Si.
    [finalH, finalB, finalS] = calculate_final(points1, points2, final_consensus);
    
end

%calculate_final implementation
%to-do