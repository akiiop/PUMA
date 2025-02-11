function [V,f,Fun_eval,angles,W]=MCBS_DecompositionV7(U,F,N,MC)
%SPSA

d = length(U);

if ~exist('F','var')||isempty(F)
    F = QuantumFourier(d);
end
if ~exist('N','var')||isempty(N)
    N=d+1;
end
if ~exist('MC','var')||isempty(MC)
    MC = 1;
end

fun = @(x)1-UnitaryFidelity(U,U_Fun(x,F,d,N));

angles = cell(1,MC);
Fun_eval = nan(1,MC);

for k = 1:MC
    angles_SPSA = SPSA(fun,pi*randn(1,(d-1)*(N+1)),1000,'Gains',[pi, pi/5, 0 , 1,1/3]);
    angles{k} = angles_SPSA(:,end).';
    Fun_eval(k) = fun(angles{k});
end

[f,Inx] = min(Fun_eval);
[V,W] = U_Fun(angles{Inx},F,d,N);

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