
d=3;
U2=ExpandMatrix(QuantumFourier(2),3,[2,3]);
U3 = QuantumFourier(3);

psi_MBS = @(x)  diag(exp(1i*x(3:5)))*U3'*diag(exp(1i*[0,x(1:2)]))*U3(:,1); 

psi = RandomState(3);

fun = @(x) 1-Fidelity(psi,psi_MBS(x));

angles = fminsearch(fun,randn(1,5));

fun(angles)
