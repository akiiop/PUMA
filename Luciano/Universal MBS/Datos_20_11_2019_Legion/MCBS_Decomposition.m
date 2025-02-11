function [V,Fun_opt,angles_opt,Fun_eval,angles,Us]=MCBS_Decomposition(U,F,N,MC)

d = length(U);

if ~exist('F','var')||isempty(F)
    F = QuantumFourier(d); %F matriz para crear las capas, QFT por defecto
end
if ~exist('N','var')||isempty(N)
    N=d+1; %numero de capas
end
if ~exist('MC','var')||isempty(MC)
    MC = 10; %Repeticiones para evitar minimos locales
end

fun = @(x)1-abs(trace(U'*U_Fun(x,F,d,N)))^2/d^2;

angles = cell(1,MC);
Fun_eval = nan(1,MC);
options = optimoptions('fminunc','Algorithm','quasi-newton','Display','off');

for k = 1:MC
    angles{k} = fminunc(fun,2*pi*rand(1,(d-1)*(N+1)),options);
    Fun_eval(k) = fun(angles{k});
end

[Fun_opt,Inx] = min(Fun_eval);
angles_opt = angles{Inx};
[V,Us] = U_Fun(angles_opt,F,d,N);

end

function [U,Us] = U_Fun(angles,F,d,N)

U = diag( exp( 1i*[0,angles(1:d-1)] ) );
Us = cell(N+1,1);
Us{1} = U;
for k = 1:N
    Us{k+1} = diag( exp( 1i*[0,angles(d+(d-1)*(k-1):d-1+(d-1)*k)] ) )*F*U;
    U = Us{k+1};
end

end

function F = QuantumFourier(d)

 F = exp(1i*2*pi*(0:(d-1))'*(0:(d-1))/d)/sqrt(d);

end