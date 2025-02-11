d = 3;
U2 = QuantumFourier(2);
U3 = QuantumFourier(3);

U_MBS = @(x)  diag(exp(1i*x(7:9)))*U3*diag(exp(1i*[x(5:6),0]))*...
            ExpandMatrix(U2,d,[2,3])*ExpandMatrix(diag(exp(1i*x(4))),d,2)*...
            ExpandMatrix(U2,d,[1,2])*ExpandMatrix(diag(exp(1i*x(3))),d,1)*...
            U3*diag(exp(1i*[x(1:2),0]));
                
MC_States = 100;
MC_Repeat = 100;
angles = cell(MC_States,MC_Repeat);
F = nan(MC_States,MC_Repeat);
options = optimset('MaxFunEvals',2000*11,'MaxIter',20000*11);

parfor j = 1: MC_States
    U = RandomUnitary(3);
    fun = @(x) 1-UnitaryFidelity(U,U_MBS(x));
    for k=1:MC_Repeat
        angles{j,k} = fminunc(fun,randn(1,10),options);
        F(j,k) = fun(angles{j,k});
    end
end

f=min(F,[],2);

figure(1),histogram(log10(F))
figure(2),histogram(log10(f))