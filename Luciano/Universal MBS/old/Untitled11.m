d = 3;
U2 = QuantumFourier(2);

U_MBS = @(x) diag(exp(1i*x(7:9)))...
            *ExpandMatrix(U2,d,[2,3])*ExpandMatrix(diag(exp(1i*x(6))),d,2)...
            *ExpandMatrix(U2,d,[1,2])*ExpandMatrix(diag(exp(1i*x(5))),d,1)...
            *ExpandMatrix(U2,d,[2,3])*ExpandMatrix(diag(exp(1i*x(4))),d,2)...
            *ExpandMatrix(U2,d,[1,2])*ExpandMatrix(diag(exp(1i*x(3))),d,1)...
            *ExpandMatrix(U2,d,[2,3])*ExpandMatrix(diag(exp(1i*x(2))),d,2)...
            *ExpandMatrix(U2,d,[1,2])*ExpandMatrix(diag(exp(1i*x(1))),d,1);

%U = RandomUnitary(d);
fun = @(x) 1-UnitaryFidelity(U,U_MBS(x));   
 
 problem = createOptimProblem('fmincon','objective',fun,'x0',zeros(1,9));
         
 gs = GlobalSearch('Display','iter');
 
 [x,fval] = run(gs,problem)
 