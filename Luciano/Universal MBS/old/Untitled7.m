
MC = 100;
Re = 10;

for d = 3:4
    Fid = nan(MC,1);
    Fid_all = nan(MC,Re);
    Us = nan(d,d,MC);
    
    for k = 1:MC
        U = RandomUnitary(d);
        Us(:,:,k) = U;
        [~,bb,cc] = MCBS_DecompositionV5(U,[],d,Re);
        Fid(k) = bb;
        Fid_all(k,:) =cc(:)';
    end
    
    %%
    save(sprintf('Datos_D%d_QE',d))
     
    figure(d)
    subplot(2,1,1)
    histogram(log10(Fid));
    subplot(2,1,2)
    histogram(log10(Fid_all));
    
end
