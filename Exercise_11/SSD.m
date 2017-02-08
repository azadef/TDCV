function score =SSD(I,T,x,y)
    [m,n,~] = size(T);
    score = sum(sum((T-I(x:x+m-1,y:y+n-1)).^2)) + 1;
end