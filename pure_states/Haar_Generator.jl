using HDF5, LinearAlgebra

MC=5*10^2;
file=h5open("HaarStates.h5","w");
Dims=collect(3:10);
DimN=size(Dims)[1];
file["dimensions"]=Dims
file["montecarlo"]=[MC]
for i=1:DimN
    z=randn(Dims[i],MC)+1im*randn(Dims[i],MC);
    states=z./sqrt.(sum(abs2.(z),dims=1))
    file["statesdim="*string(Dims[i])]=states
end
close(file)
