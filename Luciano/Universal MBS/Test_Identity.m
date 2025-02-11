Is = nan(10,2);

parfor d=13:16
    U = eye(d);
    W = Multiport_Decomposition(U,[],d,20,'GS');
    V = Multiport_Decomposition(U,[],d+1,20,'GS');
    Is(d-2,:)=[1-UnitaryFidelity(U,W),1-UnitaryFidelity(U,V)];
end

Is(Is<=0) = eps;

plot(13:16,log10(Is(11:14,:)),'-o')

%%

load('Data_Identities.mat')
Is = Data_Identities{3};
plot(3:16,log10(Is),'-o')
xlabel('Dimension')
ylabel('Infidelity')

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'FigureIdentities','-dpdf')

