using HDF5, LinearAlgebra

MC=1000;
file=h5open("HaarUnitary.h5","w");
Dims=collect(3:10);
DimN=size(Dims)[1];
file["dimensions"]=Dims
file["montecarlo"]=[MC]

for i=1:DimN
#     z=randn(Dims[i],MC)+1im*randn(Dims[i],MC);
#     states=z./sqrt.(sum(abs2.(z),dims=1))
    
    matrices =  qr( randn(Dims[i],Dims[i])+1im*randn(Dims[i],Dims[i]) ).Q;
    file["unitarydim="*string(Dims[i])]=matrices
end
close(file)
