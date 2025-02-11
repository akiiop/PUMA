function N = ExpandMatrix(M,d,Indx)

N = eye(d);

N(Indx,Indx) = M; 
end

