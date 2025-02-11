%load('UnitaryMatrix7Cores.mat')
MC = 10;
d = 4;
Fid = nan(MC,1);

parfor k = 1:MC
    V = BorderRealMatrix( RandomUnitary(4));
    [a,b] = MCBS_DecompositionV3(V,[],d);
    Fid(k) = b;
end

%%

figure(15)
histogram(log10(Fid));
Fid
