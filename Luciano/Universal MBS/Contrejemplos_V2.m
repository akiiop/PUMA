load('data_contraejemplos.mat')

d = 7;
Fids = nan(100,1);
Us = data_contraejemplos{d-2}{1}; 

for k = 1:100
    k
    U = Us(:,:,k);
    [a,b]=Multiport_Decomposition(U,[],[],3*10,'MGS');
    Fids(k) = b;
end

%%

Fid = data_contraejemplos{d-2}{2}.'; 

indx = find(Fids<Fid(:,1));
[Fids(indx),Fid(indx,1)]

Fid(indx,1) = Fids(indx);
data_contraejemplos{d-2}{2} = Fid;
save('data_contraejemplos','data_contraejemplos');



