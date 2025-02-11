
Fid = nan(100,1);
MC = 1000;
data_d_plus_2 = cell(8,1);

for d = 3:10
    Ues = nan(d,d,MC);
    for k = 1:MC
        U = RandomUnitary(d);
        Ues(:,:,k) = U;
        [a,b] = Multiport_Decomposition(U,[],d+2,4*8,'MS');
        Fid(k) = b; 
    end
    Fid(Fid<=0) = eps;
    data_d_plus_2{d-2} = {Ues,Fid};
    save('data_d_plus_2_v0.mat','data_d_plus_2')
end


%%
for d = 3:10

subplot(3,3,d-2)
histogram(log10(data_d_plus_2{d-2}{2}))
hold on


end


fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'Figure_D_plus_2_both','-dpdf')

