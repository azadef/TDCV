function E = Energy(R,T,A,M,m)
    %Generating the euler angles from tip3, not sure
    
    ra = R(1);
    rb = R(2);
    rg = R(3);
    t1 = T(1);
    t2 = T(2);
    t3 = T(3);

    R = rotation_matrix(R);
    T = [t1;t2;t3];
    RT = [R,T];
    
    E = sum(sum((A*RT*M-m).^2));
    
%     R = rotm2eul(R);
%     %d = A*(M*R'+T);
%     RT = horzcat(R,T);
%     d = (M*R'+repmat(T', [size(M, 1), 1]))*A';
%     %normalizing the 2D projection by dividing by z
%     %d = d(:, 1:2) ./ repmat(d(:, 3), [1 2]); 
%     E =sum(sum((d-m).^2));
end