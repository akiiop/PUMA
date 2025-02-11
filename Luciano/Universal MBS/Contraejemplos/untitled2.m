
load('data_contraejemplos.mat')

Peores_Matrices = cell(1,8);

for k = 1:8
    d = k+2;
    Fid = data_contraejemplos{k}{2};
    [a,b] = max(Fid(:,1));
    [d,a,Fid(b,2)]
    Peores_Matrices{k} = data_contraejemplos{k}{1}(:,:,b);
end

%save('Peores_Matrices','Peores_Matrices')
InnerProductMatrices_new(