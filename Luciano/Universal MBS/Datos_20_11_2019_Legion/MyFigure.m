for d=3:10
    
load(sprintf('Datos_D%d',d))

subplot(4,4,2*(d-3)+1)
histogram(log10(Fid(:,1)))
title(sprintf('d layers, d=%d',d))
subplot(4,4,2*(d-3)+2)
histogram(log10(Fid(:,2)))
title(sprintf('d+1 layers, d=%d',d))

end

%%
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'MySavedFile','-dpdf')
