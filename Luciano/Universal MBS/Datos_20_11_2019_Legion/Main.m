
MC = 5000; %Tama?o del MonteCarlo
Re = 100; %Repeticiones

for d = 3:10
    Fid = nan(MC,2);
    Fid_all = nan(MC,Re,2);
    
    parfor k = 1:MC
        U = RandomUnitary(d); %Matriz unitaria aleatoria
        [~,b,c] = MCBS_Decomposition(U,[],d,Re); %Descomposici?n con d capas
        [~,bb,cc] = MCBS_Decomposition(U,[],d+1,Re); %Descomposicion con d? capas
        Fid(k,:) = [b,bb];
        Fid_all(k,:,:) =[c(:),cc(:)];
    end
    
    %%
    
    save(sprintf('Datos_D%d',d)) %Guardar datos
     
%     figure(d)
%     subplot(2,2,1)
%     histogram(log10(Fid(:,1)));
%     subplot(2,2,2)
%     histogram(log10(Fid(:,2)));
%     subplot(2,2,3)
%     histogram(log10(Fid_all(:,:,1)));
%     subplot(2,2,4)
%     histogram(log10(Fid_all(:,:,2)));
%     
end
