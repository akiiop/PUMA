
Data_D_Layers = nan(5000,8);
Data_Dplus1_Layers = nan(5000,8);

for d=3:10

load(sprintf('Datos_D%d',d))

    Data_D_Layers(:,d-2) = Fid(:,1);
    Data_Dplus1_Layers(:,d-2) = Fid(:,2);
end

Data_Fig_1 = {Data_D_Layers,Data_Dplus1_Layers};

save('Data_Fig_1','Data_Fig_1')

%%
load('data_contraejemplos.mat')

Data_D_Layers = nan(1000,8);
Data_Dplus1_Layers = nan(1000,8);

for d=3:10
    Fid=data_contraejemplos{d-2}{2};
    Data_D_Layers(:,d-2) = Fid(:,1);
    Data_Dplus1_Layers(:,d-2) = Fid(:,2);
end

Data_Fig_2 = {Data_D_Layers,Data_Dplus1_Layers};

save('Data_Fig_2','Data_Fig_2')
