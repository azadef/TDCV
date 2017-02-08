function score =NCC(I,T,x,y)
    [m,n,~] = size(T);
    nom = sum(sum(T.*I(x:x+m-1,y:y+n-1)));
    denom = sqrt(sum(sum(T.^2))) * sqrt(sum(sum(I(x:x+m-1,y:y+n-1).^2)));
    score = nom/denom;
end