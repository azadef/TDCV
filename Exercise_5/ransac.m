function [finalH, p1, p2] = ransac(points1, points2, t, T, N)

assert(size(points1, 1) == size(points2, 1));

ptSize = size(points1, 1);
consensus = [];
cSize = 0;

for n = 1:N
%     sampleSize = 4 + (ptSize - 4).*rand(100,1);
    sampleSize = randi([4 ptSize]);
    sample = randsample(ptSize, sampleSize);
    
    sample1 = points1(sample, :);
    sample2 = points2(sample, :);
    
    H = DLT(sample1, sample2);

end
