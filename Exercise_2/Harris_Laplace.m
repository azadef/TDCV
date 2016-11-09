function [points] = Harris_Laplace(I,n,s0,k,alpha, th, tl)
% I = input image   n = resolution level    s0 = initial scale
% k = difference between resolution levels  alpha = 
    %for every scaled image apply harris detector
    Dx = [-1 0 1;-1 0 1;-1 0 1];
    Dy = Dx';
    
    descriptor = cell(1,n+1);
    laplacian = zeros(size(I,1),size(I,2),n+1);
    for i=0:n
        descriptor{1,i+1} = harris_det(I,i,s0,k,alpha,th);
        s_n = s0 * k^i;
        % L(x,s) = G(s) * I(x) , x = (x,y)
        [mask_x, mask_y] = G_1D(s_n);
        G_xy = conv2(conv2(I,mask_x,'same'),mask_y,'same');
        %Laplacian equation
        laplacian_i = abs(s_n^2 * (conv2(conv2(G_xy,Dx,'same'),Dx,'same') ...
            + conv2(conv2(G_xy,Dy,'same'),Dy,'same')));
        laplacian_i(laplacian_i < tl) = 0;
        laplacian(:,:,i+1) = laplacian_i;
    end
    points = [];
    %F(x,sn) > F(x,sn-1) and F(x,sn) > F(x,sn+1)   
    for j=2:n
        h = descriptor{1,j};
        for i = 1:size(h, 1)
            row = h(i,1);
            col = h(i,2);
            if laplacian(row, col, j) > laplacian(row, col, j-1) && laplacian(row, col, j) > laplacian(row, col, j+1)
                points = [points; row, col, k^(j-1)];
            end
        end
    end
end