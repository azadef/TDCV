close all;
clear;
%% Get the Integral Image
I = double(imread('Ex04Files/2007_000032.jpg'));
Y_s = size(img, 1);
X_s = size(img, 2);

Trees = cell(10,1);
heat_map = zeros(Y_s, X_s);

J = integralIm(I);

for i=1:Y_s
    for j=1:X_s
        [px, py] = getTreeValue(J,i,j);
        if px >= 1 && px <= X && py >= 1 && py <= Y
            heat_map(py, px) = heat_map(py, px) + 1;
        end
    end
end

function [px, py] = getTreeValue(J,x,y)
    %for each node in tree if featureTest true go left, if false go right
    %until you reach a leaf
end
function out = featureTest(J,x,x0,x1,y,y0,y1,z0,z1,s,t)
    out = b(J,x,x0,y,y0,2-z0,s) - b(J,x,x1,y,y1,2-z1,s) < t
end
function out = b(J,x,xi,y,yi,z,s)
    out = (J(x+xi+s,y+yi+s,z) - J(x+xi-s,y+yi+s,z) - ...
    J(x+xi+s, y+yi-s,z) - J(x+xi-s, y+yi-s,z))/(1+2*s)^2;
end