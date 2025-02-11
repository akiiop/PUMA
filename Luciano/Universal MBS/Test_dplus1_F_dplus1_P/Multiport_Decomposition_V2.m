function [V,Fun_eval,angles,W]=Multiport_Decomposition_V2(U,F,N,MC,method,x0)
%Global search

d = length(U);

if ~exist('F','var')||isempty(F)
    F = QuantumFourier(d);
end
if ~exist('N','var')||isempty(N)
    N = d+1;
end
if ~exist('MC','var')||isempty(MC)
    MC = 4;
end
if ~exist('method','var')||isempty(method)
    method = 'MS';
end
if ~exist('x0','var')||isempty(x0)
    x0 = zeros(1,(d-1)*(N));
end

fun = @(x)1-UnitaryFidelity(d,U,U_Fun(x,F,d,N));


switch method
    case 'MS'
        angles = cell(1,MC);
        Fun_eval = ones(1,MC);
        options = optimoptions('fminunc','Algorithm','quasi-newton','Display','off','MaxFunEvals',2000*(d-1)*(N),'MaxIter',2000*(d-1)*(N));
        
        for k = 1:MC
            if k == 1
                x0_temp = x0;
            else
                x0_temp = pi*(2*rand(1,(d-1)*(N))-1);
            end
            [angles{k}, Fun_eval(k)] = fminunc(fun,x0_temp,options);
        end

        [Fun_eval,Inx] = min(Fun_eval);
        angles = angles{Inx};
        
    case 'GS'
        options = optimoptions('fmincon','MaxIterations',2000*(d-1)*(N),'MaxFunctionEvaluations',2000*(d-1)*(N));
        problem = createOptimProblem('fmincon','objective',fun,'x0',x0,...
            'lb',-pi*ones(1,(d-1)*(N+1)), 'ub',pi*ones(1,(d-1)*(N+1)),...
            'options',options);
        gs = GlobalSearch('FunctionTolerance',1e-6,'NumTrialPoints',200,'NumStageOnePoints',50,'StartPointsToRun','bounds');
        [angles,Fun_eval] = run(gs,problem);
    case 'MGS'
        angles = cell(1,MC);
        Fun_eval = ones(1,MC);
        for k = 1:MC
            if k == 1
                x0_temp = x0;
            else
                x0_temp = pi*(2*rand(1,(d-1)*(N))-1);
            end
            options = optimoptions('fmincon','MaxIterations',2000*(d-1)*(N),'MaxFunctionEvaluations',2000*(d-1)*(N) );
            problem = createOptimProblem('fmincon','objective',fun,'x0',x0_temp,...
                'lb',-pi*ones(1,(d-1)*(N)), 'ub',pi*ones(1,(d-1)*(N)),...
                'options',options);
            gs = GlobalSearch('FunctionTolerance',1e-6,'NumTrialPoints',200,'NumStageOnePoints',50,'StartPointsToRun','bounds','Display','off');
            [angles{k},Fun_eval(k)] = run(gs,problem);
        end
        [Fun_eval,Inx] = min(Fun_eval);
        angles = angles{Inx};
        
end

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
end

function F = UnitaryFidelity(d,U,V)

F = abs(trace(U'*V))/d ;
F = F^2;

end

function F = QuantumFourier(d)

 F = exp(1i*2*pi*(0:(d-1))'*(0:(d-1))/d)/sqrt(d);

end