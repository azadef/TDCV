close all;
clear;

I = double(imread('Ex04Files/2007_000032.jpg'));
I = padarray(I,[500 500]);
numberOfTree = 10;
trees = cell(numberOfTree, 2);

for n = 0:numberOfTree-1
    
    %reading tree files
    filename = sprintf('Ex04Files/Tree%d.txt', n);
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

%Get the Integral Image

Y_s = size(I, 1);
X_s = size(I, 2);

% Trees = cell(10,1);
heat_map = zeros(Y_s, X_s);

J = integralIm(I);

for i=1:Y_s
    for j=1:X_s
        [px, py] = getTreeValue(J,i,j,trees);
        if px >= 1 && px <= X && py >= 1 && py <= Y
            heat_map(py, px) = heat_map(py, px) + 1;
        end
    end
end

function [px, py] = getTreeValue(J,x,y,trees)
    %for each node in tree if featureTest true go left, if false go right
    %until you reach a leaf
    for n = 1:10
        temp = trees{n,1};
        row = temp(1,:);
        cL = 19;
        cR = 19;
        while ((cL >=1) || (cR >=1))
        i= row(1,1);
        cL = row(1,2);
        cR = row(1,3);
        t = row(1,4);
        x0 = row(1,5);
        y0 = row(1,6);
        z0 = row(1,7);
        x1 = row(1,8);
        y1 = row(1,9);
        z1 = row(1,10);
        s = row(1,11);
        th_result = featureTest(J,x+500,x0,x1,y+500,y0,y1,z0,z1,s,t);
        if (th_result==1)
            row = temp(cL,:);
        else
            row = temp(cR,:);
        end
        end
        l = trees{n,2};
        if(cL < 1)
            row =  l(abs(cL),:);
            px = row(1,2);
            py = row(1,3);
        elseif (cR < 1)
            row =  l(abs(cR),:);
            px = row(1,2);
            py = row(1,3);
        end
    end
    
end
function out = featureTest(J,x,x0,x1,y,y0,y1,z0,z1,s,t)
    out = b(J,x,x0,y,y0,z0,s) - b(J,x,x1,y,y1,z1,s) < t;
end
function out = b(J,x,xi,y,yi,z,s)
    out = (J(x+xi+s,y+yi+s,z) - J(x+xi-s,y+yi+s,z) - ...
    J(x+xi+s, y+yi-s,z) - J(x+xi-s, y+yi-s,z))/(1+2*s)^2;
end

function rgb = colorChannelAssignment(rgb)
u = size(rgb,1);
for i = 1:u
if (rgb(i,1) == 0)
    rgb(i,1) = 3;
elseif (rgb(i,1) == 1)
    rgb(i,1) = 2;
else
    rgb(i,1) = 1;    
end
end
end