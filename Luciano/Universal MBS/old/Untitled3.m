
%U3 = QuantumFourier(3);
U3=exp(1i*[ -1 11 11;11 -1 11; 11 11 -1 ]*pi/18)/sqrt(3);

U_MBS = @(x) diag(exp(1i*x(1:3)))*U3...
                *diag(exp(1i*[0,x(4:5)]))*U3...
                *diag(exp(1i*[0,x(6:7)]))*U3...
                *diag(exp(1i*[0,x(8:9)]))*U3...
                *diag(exp(1i*[0,x(10:11)]));

MC_states = 100;
MC_Repeat = 100;
F = nan(MC_states,MC_Repeat);
options = optimset('MaxFunEvals',2000*11,'MaxIter',20000*11);

parfor j = 1:MC_states
    U = RandomUnitary(3);
    fun = @(x) 1-UnitaryFidelity(U,U_MBS(x));
    
    for k= 1:MC_Repeat 
        angles = fminunc(fun,randn(1,11),options);
        V = U_MBS(angles);
        F(j,k) = fun(angles); 
    end
end

f=min(F,[],2);

histogram(log10(F'))
hold on
histogram(log10(f))
hold off

