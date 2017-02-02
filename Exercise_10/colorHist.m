function hist = colorHist(roi)
   %converting from RGB system to HSV system
    hsv = rgb2hsv(roi);
    %taking out of the hue part for plotting histogram
    hue = hsv(:, :, 1);
    %as mentioned in exercise we are using 0 to 255 space for plotting
    %colors
    hist = zeros(256, 1);
    %normalising hue in [0 255] interval
    index = ceil(hue*255) + 1;
    %calculating number of elements in interval [0 255]
    for n = 1:numel(index)
        hist(index(n)) = hist(index(n)) + 1;
    end
end