function [T, normPoints] = normalize(points)
    n = size(points,2);
    centroid = mean(points,2);
    normPoints = points;
    normPoints(1:2,:) = points(1:2,:) - repmat(centroid(1:2),1,n);
    %Scale points to have average distance from the origin sqrt(2)
    scale = sqrt(2) / mean( sqrt(sum(normPoints(1:2,:).^2)) );
    normPoints(1:2,:) = scale*normPoints(1:2,:);
    %Composition of the normalization matrix.
    T = diag([scale scale 1]);
    T(1:2,3) = -scale*centroid(1:2);
end