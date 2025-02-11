for d=9:10
    
load(sprintf('Datos_D%d',d))

subplot(4,4,2*(d-3)+1)
histogram(log10(Fid(:,1)))
title(sprintf('d layers, d=%d',d))
subplot(4,4,2*(d-3)+2)
histogram(log10(Fid(:,2)))
title(sprintf('d+1 layers, d=%d',d))

end