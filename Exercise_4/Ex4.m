close all;
clear;

numberOfTree = 10;
trees = cell(numberOfTree, 2);

for n = 0:numberOfTree-1
    
    %reading tree files
    filename = sprintf('Tree%d.txt', n);
    file = fopen(filename);
    
    %storing number of nodes
    N = textscan(file, '%d', 1);
    cell_node = textscan(file, '%d %d %d %f %d %d %d %d %d %d %d', N{1});
    
    %storing the attributes of nodes from cells into array
    nodes = zeros(N{1}, numel(cell_node));
    for i = 1:numel(cell_node)
        nodes(:, i) = cell_node{i};
    end    
    
    %changing color columns as mentioned in FAQ from BGR to RGB
    nodes(:, 7) = colorChannelAssignment(nodes(:, 7));
    nodes(:, 10) = colorChannelAssignment(nodes(:, 10));
    
    %storing number of leafs
    M = textscan(file, '%d', 1);
    cell_leaf = textscan(file, '%d %f %f', M{1});
    
    %storing the attributes of leafs from cells into array
    leafs = zeros(M{1}, numel(cell_leaf));
    for i = 1:numel(cell_leaf)
        leafs(:, i) = cell_leaf{i};
    end
    
    %adding tree attributes to cell
    %1st column cells is for nodes
    %2nd column cells for leafs
    trees{n+1,1} = nodes;
    trees{n+1,2} = leafs;
end

function rgb = colorChannelAssignment(rgb)
if (rgb == 0)
    rgb = 2;
end
if (rgb == 0)
    rgb = 0;
end
end

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