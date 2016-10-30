function [J] = Conv(I,H,border)
    size_I = size(I);
    size_H = size(H);
    M = size_H(1);
    N = size_H(2);
    I = double(I);
    border_name = 'replicate';
    if border == 1
        border_name = 'symmetric';
    end
    I_bordered = padarray(I,[(M+1)/2 (N+1)/2],border_name,'both');
    J = zeros(size_I);
    
    for x=1:size_I(1)
        for y=1:size_I(2)
            J(x,y) = sum(sum(I_bordered(x:x+M-1,y:y+N-1) .* H));
        end
    end
end