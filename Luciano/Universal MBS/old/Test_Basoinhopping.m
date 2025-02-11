
%Rosenbrock Function, global minimum in (a,a^2)
a = 10*rand;
b = 100*rand;
fun = @(x) (a-x(1))^2+b*(x(2)-x(1)^2  )^2;

x_opt = [a,a^2];

MC=100;
x1 = nan(MC,2);
x2 = x1;

for k=1:MC

%Initial condition
x0 =100*rand(1,1); 

x1(k,:) = fminunc(fun,[10,10]);

x2(k,:) = BasinHopping(fun,[10,10],10);

end




