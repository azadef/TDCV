function E = Energy(R,T,A,M,m)
    %Generating the euler angles from tip3, not sure
    R = rotm2eul(R);
    d = A*(R*M+T);
    %normalizing the 2D projection by dividing by z
    d = d(:, 1:2) ./ repmat(d(:, 3), [1 2]); 
    E =sum((d-m).^2);
end