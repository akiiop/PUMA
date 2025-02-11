function [V,Fun_eval,angles,W]=MCBS_DecompositionV3(U,F,N)
%Global search

d = length(U);

if ~exist('F','var')||isempty(F)
    F = QuantumFourier(d);
end
if ~exist('N','var')||isempty(N)
    N = d;
end

fun = @(x)1-UnitaryFidelity(U,U_Fun(x,F,d,N));

% opts = optimoptions('fminunc','MaxIterations',4000,'MaxFunctionEvaluations',1000*(d-1)*(N+1) );
% problem = createOptimProblem('fminunc','objective',fun,'x0',zeros(1,(d-1)*(N+1)),'options',opts);
% gs = MultiStart;
% [angles,Fun_eval] = run(gs,problem,(d-1)*(N+1));

opts = optimoptions('fmincon','MaxIterations',1000*(d-1)*(N+1),'MaxFunctionEvaluations',1000*(d-1)*(N+1) );
problem = createOptimProblem('fmincon','objective',fun,'x0',zeros(1,(d-1)*(N+1)),...
                             'lb',-pi*ones(1,(d-1)*(N+1)), 'ub',pi*ones(1,(d-1)*(N+1)),...
                             'options',opts);
gs = GlobalSearch('StartPointsToRun','bounds');
[angles,Fun_eval] = run(gs,problem);

[V,W] = U_Fun(angles,F,d,N);
V = V*exp(1i*(angle(U(1,1))-angle(V(1,1)) )); 
end

function [U,asd] = U_Fun(angles,F,d,N)

U=eye(d);
asd = cell(N,1);
for k = 1:N
    U = F*diag( exp( 1i*[0,angles(1+(d-1)*(k-1):(d-1)*k )] ) )*U;
    asd{k} = U;
end
U=diag( exp( 1i*[0,angles(end-d+2:end)] ) )*U;

end

function F = UnitaryFidelity(U,V)

F = abs(trace(U'*V))/abs( sqrt( trace(U'*U)*trace(V'*V) ) );
F = F^2;

end

function F = QuantumFourier(d)

 F = exp(1i*2*pi*(0:(d-1))'*(0:(d-1))/d)/sqrt(d);

end