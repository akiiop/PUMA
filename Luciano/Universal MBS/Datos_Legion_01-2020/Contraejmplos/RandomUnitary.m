function U = RandomUnitary(n,m)

if ~exist('m','var')
    m=n;
end

X = (randn(n) + 1i*randn(n))/sqrt(2);
[Q,R] = qr(X);
R = diag(diag(R)./abs(diag(R)));
U = Q*R; U=U(:,1:m);

end