run('VLFEATROOT/toolbox/vl_setup')
run('matconvnet/matlab/vl_setupnn');


P = imread('pot.jpg');
P = imresize(P, 0.125);
P = single(rgb2gray(P));

S = imread('shell.jpg');
S = imresize(S, 0.125);
S = single(rgb2gray(S));

I1 = imread('test_pot1.jpg');
% I1 = imresize(I1, 0.25);
I1 = single(rgb2gray(I1));

I2 = imread('test_pot2.jpg');
% I2 = imresize(I2, 0.25);
I2 = single(rgb2gray(I2));

I3 = imread('test_shell1.jpg');
% I3 = imresize(I3, 0.25);
I3 = single(rgb2gray(I3));

I4 = imread('test_shell2.jpg');
% I4 = imresize(I4, 0.25);
I4 = single(rgb2gray(I4));

cellSize = 8 ;
hog_p = vl_hog(P, cellSize, 'verbose') ;
imhog_p = vl_hog('render', hog_p, 'verbose') ;
figure(1);
clf ; imagesc(imhog_p) ; colormap gray ;

hog_s = vl_hog(S, cellSize, 'verbose') ;
imhog_s = vl_hog('render', hog_s, 'verbose') ;
figure(2);
clf ; imagesc(imhog_s) ; colormap gray ;

% Dalal-Triggs variant
% cellSize = 8 ;
% hog1 = vl_hog(O2, cellSize, 'verbose', 'variant', 'dalaltriggs') ;
% imhog1 = vl_hog('render', hog1, 'verbose', 'variant', 'dalaltriggs') ;
% figure(2);
% clf ; imagesc(imhog1) ; colormap gray ;

cellSize = 8;
scales = [0.1:0.05:0.3];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Test image 1 for Pot %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

best_score = 0;
for s = scales
                test_img = imresize(I1, s);
                hog_test = vl_hog(test_img, cellSize);
                im1 = vl_hog('render', hog_test);

                scores = vl_nnconv(hog_test, hog_p, []);
                max_score = max(max(scores));
                
                if max_score > best_score
                    best_score = max_score;
                    best_scores = scores;
                    best_im = im1;
                    best_hog = hog_test;
                    best_img = test_img;
                end
end

figure(3)
imshow(best_im);            
title('test_pot1.jpg');

[y0, x0] = ind2sub(size(best_scores), find(best_scores == best_score));
pos = [x0 y0 size(hog_p, 2) size(hog_p, 1)] * cellSize;

figure(4)
imshow(best_img/255);
rectangle('Position', pos, 'EdgeColor', 'r', 'LineWidth', 3);
text(pos(1), pos(2)+pos(4)/2, num2str(max_score), 'Color', 'g');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Test image 2 for Pot %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

best_score = 0;
for s = scales
                test_img = imresize(I2, s);
                hog_test = vl_hog(test_img, cellSize);
                im1 = vl_hog('render', hog_test);

                scores = vl_nnconv(hog_test, hog_p, []);
                max_score = max(max(scores));
                
                if max_score > best_score
                    best_score = max_score;
                    best_scores = scores;
                    best_im = im1;
                    best_hog = hog_test;
                    best_img = test_img;
                end
end

figure(5)
imshow(best_im);            
title('test_pot2.jpg');

[y0, x0] = ind2sub(size(best_scores), find(best_scores == best_score));
pos = [x0 y0 size(hog_p, 2) size(hog_p, 1)] * cellSize;

figure(6)
imshow(best_img/255);
rectangle('Position', pos, 'EdgeColor', 'r', 'LineWidth', 3);
text(pos(1), pos(2)+pos(4)/2, num2str(max_score), 'Color', 'g');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Test image 1 for shell %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

best_score = 0;
for s = scales
                test_img = imresize(I3, s);
                hog_test = vl_hog(test_img, cellSize);
                im1 = vl_hog('render', hog_test);

                scores = vl_nnconv(hog_test, hog_s, []);
                max_score = max(max(scores));
                
                if max_score > best_score
                    best_score = max_score;
                    best_scores = scores;
                    best_im = im1;
                    best_hog = hog_test;
                    best_img = test_img;
                end
end

figure(7)
% subplot(m, n, 1 + j + offset);
imshow(best_im);            
title('test_shell1.jpg');

[y0, x0] = ind2sub(size(best_scores), find(best_scores == best_score));
pos = [x0 y0 size(hog_s, 2) size(hog_s, 1)] * cellSize;

figure(8)
% subplot(2, 2, (i-1)*2 + j);
imshow(best_img/255);
rectangle('Position', pos, 'EdgeColor', 'r', 'LineWidth', 3);
text(pos(1), pos(2)+pos(4)/2, num2str(max_score), 'Color', 'g');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Test image 2 for shell %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

best_score = 0;
for s = scales
                test_img = imresize(I4, s);
                hog_test = vl_hog(test_img, cellSize);
                im1 = vl_hog('render', hog_test);

                scores = vl_nnconv(hog_test, hog_s, []);
                max_score = max(max(scores));
                
                if max_score > best_score
                    best_score = max_score;
                    best_scores = scores;
                    best_im = im1;
                    best_hog = hog_test;
                    best_img = test_img;
                end
end

figure(7)
imshow(best_im);            
title('test_shell2.jpg');

[y0, x0] = ind2sub(size(best_scores), find(best_scores == best_score));
pos = [x0 y0 size(hog_s, 2) size(hog_s, 1)] * cellSize;

figure(8)
imshow(best_img/255);
rectangle('Position', pos, 'EdgeColor', 'r', 'LineWidth', 3);
text(pos(1), pos(2)+pos(4)/2, num2str(max_score), 'Color', 'g');

