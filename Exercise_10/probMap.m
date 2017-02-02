function map = probMap(roi, hist)
    %converting from RGB system to HSV system
    hsv = rgb2hsv(roi);
    hue = hsv(:, :, 3);
    %normalising hue in [0 255] interval
    index = ceil(hue*255) + 1;
    %number of elements of same color at each position
    map = hist(index);
    %normalization
    map = single(map) / max(map(:)) * 255;
end