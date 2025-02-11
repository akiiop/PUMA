
MC = 900;

data_contraejemplos = cell(1,8);

for d = 3:10

if mod(d,2)==0 
    d1=d/2;
    d2=d1;
else
    d1=(d-1)/2;
    d2=(d+1)/2;
end

Us = nan(d,d,MC);
Fs = nan(2,MC);

parfor k=1:MC
    U = blkdiag(RandomUnitary(d1),RandomUnitary(d2));
    Us(:,:,k) = U;
    [a,b] = Multiport_Decomposition(U,[],d,50);
    [a2,b2] = Multiport_Decomposition(U,[],d+1,50);
    Fs(:,k) = [b,b2];
end

data_contraejemplos{d-2} = {Us,Fs};
save('data_contraejemplos','data_contraejemplos');

end

%%
% 
% load('data_contraejemplos');

for d=3:10

Fid = data_contraejemplos{d-2}{2}.';
    
subplot(4,4,2*(d-3)+1)
histogram(log10(Fid(:,1)))
title(sprintf('d layers, d=%d',d))
subplot(4,4,2*(d-3)+2)
histogram(log10(Fid(:,2)))
title(sprintf('d+1 layers, d=%d',d))

end
% 
% 
% fig = gcf;
% fig.PaperPositionMode = 'auto';
% fig_pos = fig.PaperPosition;
% fig.PaperSize = [fig_pos(3) fig_pos(4)];
% print(fig,'FigureContraExamples','-dpdf')

%%

   
load('data_contraejemplos.mat')
U3=data_contraejemplos{1}{1};
d3=data_contraejemplos{1}{2};
   
Fids = nan(1,100);
for k=1:100
k
[a,b] = Multiport_Decomposition(U3(:,:,k),[],[],6,'MGS');
Fids(k) = b;
end
