
load('data_contraejemplos_v1.mat')
data_contraejemplos_v1 = data_contraejemplos;

load('data_contraejemplos_v2.mat')
data_contraejemplos_v2 = data_contraejemplos;

data_contraejemplos = cell(1,8);

%%

for d = 7:10
    Us = nan(d,d,1000);
    Us(:,:,1:100) =  data_contraejemplos_v1{d-2}{1};
    Us(:,:,101:1000) =  data_contraejemplos_v2{d-2}{1};
    
    Fids = [data_contraejemplos_v1{d-2}{2}';data_contraejemplos_v2{d-2}{2}'];
    
    data_contraejemplos{d-2} = {Us,Fids};
end

save('data_contraejemplos','data_contraejemplos')
