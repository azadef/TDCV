function normPoints = normalize(points)
    normPoints = (points - mean(points(:))) / std(points(:));
end