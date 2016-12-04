function H = DLT(pnts1,pnts2)
    [U,pnts1] = normalize(pnts1);
    [T,pnts2] = normalize(pnts2);
    n = size(pnts1,1);
    Ai = cell(n,1);
    A = zeros(2*n,9);
    for i=1:n
      Ai{i} = [[0,0,0,-pnts1(3,i)*pnts2(:,i)',pnts1(2,i)*pnts2(:,i)'];...
          [pnts1(3,i)*pnts2(:,i)',0,0,0,-pnts1(1,i)*pnts2(:,i)']];
      A(2*i-1:2*i,:) = Ai{i};
    end
    [~,~,V] = svd(A);
    h = V(:,end);
    H = reshape(h,3,3)';
    H = inv(T)*H*U;
end