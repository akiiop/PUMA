load('data_contraejemplos_test.mat')
load('data_contraejemplos.mat')

for d = 3:9
    Fid_new = data_contraejemplos_test{d-2}{3};
    Fid_old = data_contraejemplos{d-2}{2}(:,1);
    Fid = min([Fid_new,Fid_old],[],2);
    Fid(Fid<=0) = eps;
    data_contraejemplos{d-2}{2}(:,1) = Fid;
end

save('data_contraejemplos.mat','data_contraejemplos')


%%

load('data_contraejemplos.mat')
Data_1 = nan(1000,8);
Data_2 = nan(1000,8);

for d = 3:10
    Data_1(:,d-2) = data_contraejemplos{d-2}{2}(:,1);
    Data_2(:,d-2) = data_contraejemplos{d-2}{2}(:,2);
end

Data_Fig_2 = {Data_1,Data_2};

save('Data_Fig_2','Data_Fig_2')
