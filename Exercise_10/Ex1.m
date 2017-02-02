%%Part 1

I = imread('sequence/2043_000140.jpeg');

ref = figure('Name', 'Reference Image', 'NumberTitle', 'Off');
imshow(I);

area_selected = [505 304 52 45];
% area_selected = [506 308 57 47]; % x y width height

x = figure(ref);
set(ref, 'Name', 'Reference Image with area selected');
hold on;
corners = [area_selected(1) area_selected(2);
       area_selected(1) area_selected(2)+area_selected(4);
       area_selected(1)+area_selected(3) area_selected(2)+area_selected(4);
       area_selected(1)+area_selected(3) area_selected(2);
       area_selected(1) area_selected(2);
       ];
plot(corners(:,1), corners(:,2), 'Color', 'b');
pause(3);
close(x);

roi = I(area_selected(2):area_selected(2)+area_selected(4), area_selected(1):area_selected(1)+area_selected(3), :);

hist = colorHist(roi);
map = probMap(roi, hist);

figure(2)
subplot(1, 1, 1)
bar(hist);
xlim([0 256])
title('Histogram')

figure(3)
ax = subplot(1, 1, 1);
imshow(map/255)
colormap(ax, hot)
title('Probability Map')

figure(4)
imagesc(map)