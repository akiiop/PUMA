
phi = linspace(0,2*pi,100);

V = @(phi) [1,1,1,1;1,exp(1i*phi),-1,-exp(1i*phi);1,-1,1,-1;1,-exp(1i*phi),-1,exp(1i*phi)]/2;

F = nan(100,1);

parfor k=1:100
    
    U = V(phi(k));
    [W,f] = MCBS_Decomposition(U,[],5,10);
    F(k) = f;
    
end

semilogy(phi,F,'-o')
xlim([0-0.1,2*pi+.1])
