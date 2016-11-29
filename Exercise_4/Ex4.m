close all;
clear;
%% Get the Integral Image
I = double(imread('Ex04Files/2007_000032.jpg'));
J = integralIm(I);
