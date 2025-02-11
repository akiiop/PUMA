function [V,f,Fun_eval,angles,Us]=MCBS_DecompositionV5(U,F,N,MC)

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

fun = @(x) abs(U - U_Fun(x,F,d,N));

angles = cell(1,MC);
Fun_eval = nan(1,MC);


for k = 1:MC
    angles{k} = lsqnonlin(fun,2*pi*rand(1,d*(N+1)));
    Fun_eval(k) = norm(fun(angles{k}))^2;
end

[f,Inx] = min(Fun_eval);
[V,Us] = U_Fun(angles{Inx},F,d,N);

end

function [U,Us] = U_Fun(angles,F,d,N)

U = diag( exp( 1i*angles(1:d) ) );
Us = cell(N+1,1);
Us{1} = U;
for k = 1:N
    Us{k+1} = diag( exp( 1i*angles(1+k*d:d+d*k) ) )*F*U;
    U = Us{k+1};
end

end

function F = QuantumFourier(d)

 F = exp(1i*2*pi*(0:(d-1))'*(0:(d-1))/d)/sqrt(d);

end