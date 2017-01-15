clear;
close all;
clc;

%%
load('Classifiers.mat');
faces = {'faceA.jpg','faceB.jpg','faceC.jpg'};
HF = HaarFeatures(classifiers(:,2:size(classifiers,2)));
winSize = 19;

for i=1:size(faces,2)
    figure;
    I = double(rgb2gray(imread(faces{i})));
    
    
    maxScore = 0;
    while winSize <= min(size(I))
        
        IntIm = integralIm(I);
        imSize = size(IntIm);
        for j = 1:imSize(1)-winSize+1
            for k = 1:imSize(2)-winSize+1
                score = HF.HaarFeaturesCompute(IntIm(j:j+winSize-1,k:k+winSize-1),1);
                
                if(score >= maxScore)
                    maxScore = score;
                    close;
                    figure;
                    imagesc(I), colormap gray, axis equal tight, hold on;
                    plot([k; k; k+round(winSize); k+round(winSize); k], ...
                        [j; j+round(winSize); j+round(winSize); j; j],'r');
                   
                end
                
            end
        end
        I = I(1:2:size(I,1),1:2:size(I,2));
    end
end