load('data_contraejemplos.mat');

data_contraejemplos_test = cell(1,8);

for d = 10:10
    
    Us = data_contraejemplos{d-2}{1};
    Fid = data_contraejemplos{d-2}{2};
    Fid_new = nan(1000,1);
    
    [~,Indx] = sort(Fid,'descend');
    Us = Us(:,:,Indx);
    
    for k = 1:100 
        [~,b]=Multiport_Decomposition(Us(:,:,k),[],[],4*8,'MGS');
        Fid_new(k) = b;
    end
    
    data_contraejemplos_test{d-2}={Indx,Us,Fid_new};
    save('data_contraejemplos_test.mat','data_contraejemplos_test');
end
