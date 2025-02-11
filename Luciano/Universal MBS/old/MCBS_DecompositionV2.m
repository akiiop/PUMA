function [V,f,Fun_eval,angles,W]=MCBS_DecompositionV2(U,F,N,MC,BH)
%My BasinHopping

d = length(U);

if ~exist('F','var')||isempty(F)
    F = QuantumFourier(d);
end
if ~exist('N','var')||isempty(N)
    N = d;
end
if ~exist('MC','var')||isempty(MC)
    MC = 1;
end
if ~exist('BH','var')||isempty(BH)
    BH = min([4*(floor(sqrt(d))+1),100]);
end

fun = @(x)1-UnitaryFidelity(U,U_Fun(x,F,d,N));

angles = cell(1,MC);
Fun_eval = ones(1,MC);

for k=1:MC
    if k==1
        x0 = zeros(1,(d-1)*(N+1));
    else
        x0 = pi*(2*rand(1,(d-1)*(N+1))-1);
    end
    [a_temp,f_temp] = BasinHopping(fun,x0,BH);
    angles{k} = a_temp;
    Fun_eval(k) = f_temp;
    if f_temp<1e-10
        break
    end
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

function [x0,fx0] = BasinHopping(fun,x0,K)

r = pi/2;
sz = size(x0); d = length(x0);
T = .5;
options = optimoptions('fminunc','Algorithm','quasi-newton','Display','off','MaxFunEvals',2000*d,'MaxIter',2000*d);
[x,fx] = fminunc(fun,x0,options);
x0 = x; fx0 = fx;

for k = 1:K
    v = 2*rand(sz)-1;
    [y,fy] = fminunc(fun,x+r*v,options);
    if fy<fx
        x = y; fx = fy;%Paso del BH
            if fx<fx0
                x0 = x; fx0 = fy; %Guardando Mejor Minimo
            end
    else
        E = exp(-(fy-fx)/T);
        if rand < E
            x = y; fx = fy; %Paso del BH con probabilidad E
        end
    end
    if fx0<1e-10
        break
    end
end

end