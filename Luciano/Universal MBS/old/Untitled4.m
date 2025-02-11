tic
F4 = QuantumFourier(4);
U4=[1,1,1,1;1,-1,1,-1;1,1,-1,-1;1,-1,-1,1]/2;
%U4 = RandomUnitary(4);

U_MBS = @(x) diag(exp(1i*[0,x(1:3)]))*F4...
                *diag(exp(1i*[0,x(4:6)]))*U4...
                *diag(exp(1i*[0,x(7:9)]))*F4...
                *diag(exp(1i*[0,x(10:12)]) )*U4...
                *diag(exp(1i*[0,x(13:15)]));
            
MC_States = 1;
MC_Repeat = 10000;
F = nan(MC_States,MC_Repeat);            
options = optimset('MaxFunEvals',2000*15,'MaxIter',20000*15);
Us = nan(4,4,MC_States);

for k=1
    %U = RandomUnitary(4);
    %Us(:,:,k) = U;
    U = UUs(:,:,5);
    fun = @(x) 1-UnitaryFidelity(U,U_MBS(x));
    
    parfor l=1:MC_Repeat
        angles = fminunc(fun,randn(1,15),options);
        V = U_MBS(angles);
        F(k,l) = fun(angles);
    end
end

f = min(F,[],2);

subplot(2,1,1)
histogram(log10(F))
subplot(2,1,2)
histogram(log10(f))

toc
