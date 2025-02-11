ent
d = 3;
U2 = QuantumFourier(2);
U3 = QuantumFourier(3);

U_MBS = @(x)  diag(exp(1i*x(1:3)))*U3*...
            ExpandMatrix(diag(exp(1i*x(4:5))),d,[1,2])*ExpandMatrix(U2,d,[2,3])*...
            ExpandMatrix(exp(1i*x(6)),d,2)*ExpandMatrix(U2,d,[1,3])*...
            ExpandMatrix(U2,d,[1,2])*ExpandMatrix(diag(exp(1i*x(7:8))),d,[2,3])*U3*...
            diag(exp(1i*[0,x(9:10)]));

MC_States = 10;
MC_repeat = 10;
angles = cell(MC_States,MC_repeat);
F = nan(MC_States,MC_repeat);
options = optimset('MaxFunEvals',2000*11,'MaxIter',20000*11);

parfor j = 1: MC_States
    U = RandomUnitary(3);
    fun = @(x) 1-UnitaryFidelity(U,U_MBS(x));
    for k=1:MC_repeat
        angles{j,k} = fminunc(fun,randn(1,10),options);
        F(j,k) = fun(angles{j,k});
    end
end

f=min(F,[],2);

figure(1),histogram(log10(F))
figure(2),histogram(log10(f))