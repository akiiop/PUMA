d = 3;
U2 = QuantumFourier(2);
U3= QuantumFourier(3);

U_MBS = @(x) ExpandMatrix(diag(exp(1i*x(7:8))),d,[2,3])...
            *ExpandMatrix(U2,d,[1,2])*ExpandMatrix(diag(exp(1i*x(6))),d,2)...
            *U3*ExpandMatrix(diag(exp(1i*x(4:5))),d,[2,3])...       
            *U3*ExpandMatrix(diag(exp(1i*x(3))),d,2)...
            *ExpandMatrix(U2,d,[1,2])*ExpandMatrix(diag(exp(1i*x(1:2))),d,[2,3]);
        
MC = 100; 
Re = 100;
Fid_all = nan(MC,Re);

parfor k = 1:MC
    U = RandomUnitary(d);
    fun = @(x) 1-UnitaryFidelity(U,U_MBS(x));
    for l = 1:Re
        angles = fminunc(fun,zeros(10,1));
        Fid_all(k,l) = fun(angles);
    end
end

Fid = min(Fid_all,[],2);

subplot(2,1,1)
histogram(log10(Fid))
subplot(2,1,2)
histogram(log10(Fid_all))

