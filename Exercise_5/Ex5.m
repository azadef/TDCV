close all;
clc;

I = double(imread('ex05/scene.pgm'));
J = double(imread('ex05/box.pgm'));
pnts1 = [10 20 3 15 106 16;17 18 19 20 120 34;1 1 1 1 1 1];
pnts2 = [17 18 19 20 120 34;10 20 3 15 106 16;1 1 1 1 1 1];
d = DLT(pnts1,pnts2);
disp(d);