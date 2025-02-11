function x0 = BasinHopping(fun,x0,K)

r = 0.5;
sz = size(x0); d = length(x0);
T = .5;
options = optimoptions('fminunc','Algorithm','quasi-newton','Display','off','MaxFunEvals',2000*d,'MaxIter',2000*d);
x = fminunc(fun,x0,options);
x0 = x;

for k = 1:K
    y = fminunc(fun,x+r*randn(sz),options);
    if fun(y)<fun(x0)
        x = y;
        x0 = x;
    else
        E = exp(-(fun(y)-fun(x))/T);
        if rand < E
            x = y;
        end
    end
end

end