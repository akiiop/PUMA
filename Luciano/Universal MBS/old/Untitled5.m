U5 = QuantumFourier(5);

U_MBS = @(x) diag(exp(1i*[0,x(1:4)]))*U5...
                *diag(exp(1i*[0,x(5:8)]))*U5...
                *diag(exp(1i*[0,x(9:12)]))*U5...
                *diag(exp(1i*[0,x(13:16)]))*U5...
                *diag(exp(1i*[0,x(17:20)]))*U5...
                *diag(exp(1i*[0,x(21:24)]));
 
            F = nan(100,100);
            d = 5;
            N = 5;
            options = optimoptions('fminunc','Algorithm','quasi-newton','Display','off','MaxFunEvals',2000*(d-1)*(N+1),'MaxIter',2000*(d-1)*(N+1));
            
            for k=1:100
                
                U = RandomUnitary(5);
                fun = @(x) 1-UnitaryFidelity(U,U_MBS(x));
                
                for l=1:100
                    angles = fminunc(fun,2*pi*randn(1,24),options);
                    
                    F(k,l) = fun(angles);
                end
            end

            
f = min(F,[],2);
subplot(2,1,1)
histogram(log10(f))
subplot(2,1,2)
histogram(log10(F))

