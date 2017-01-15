function J = integralIm(I)
    J = zeros(size(I,1)+1,size(I,2)+1,1);
    for i=2:size(J,1)
        for j=2:size(J,2)
            for k=1
                J(i,j,k) = I(i-1,j-1,k)+ J(i-1,j,k) + J(i,j-1,k) - J(i-1,j-1,k);
            end
        end
    end
end