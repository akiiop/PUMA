
%MC = 5000; %Tama?o del MonteCarlo
%Re = 100; %Repeticiones

MC = 5000; %Tama?o del MonteCarlo
Re = 50; %Repeticiones

for d = 9:10
    %Fid = nan(MC,2);
    %Fid_all = nan(MC,Re,2);
    load(sprintf('Datos_D%d',d))
    
    parfor k = 1:MC
        U = RandomUnitary(d); %Matriz unitaria aleatoria
        [~,b,c] = MCBS_Decomposition(U,[],d,Re); %Descomposici?n con d capas
        %[~,bb,cc] = MCBS_Decomposition(U,[],d+1,Re); %Descomposicion con d? capas
        Fid(k,1) = b;
        Fid_all(k,:,1) =c(:);
    end
    
    %%    
    save(sprintf('Datos_D%d',d)) %Guardar datos
%     
end

for d = 9:10
    %Fid = nan(MC,2);
    %Fid_all = nan(MC,Re,2);
    load(sprintf('Datos_D%d',d))
    
    parfor k = 1:MC
        U = RandomUnitary(d); %Matriz unitaria aleatoria
        [~,b,c] = MCBS_Decomposition(U,[],d+1,Re); %Descomposici?n con d+1 capas
        Fid(k,2) = b;
        Fid_all(k,:,2) =c(:);
    end
    
    %%    
    save(sprintf('Datos_D%d',d)) %Guardar datos
%     
end

