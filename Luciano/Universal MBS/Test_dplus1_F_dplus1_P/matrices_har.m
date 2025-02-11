
load('Test_dplus1_F_P.mat')


Matrices_Haar = cell(1,8);

for k=1:8
    Matrices_Haar{k} = Data{k}{2};
end

save('Matrices_Haar','Matrices_Haar')

%%

load('data_contraejemplos.mat')

Matrices_block_diag = cell(1,8);

for k=1:8
    Matrices_block_diag{k} = data_contraejemplos{k}{1};
end

save('Matrices_block_diag','Matrices_block_diag')

