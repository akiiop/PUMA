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
    
    qr( randn(Dim,Dim)+1im*randn(Dim,Dim) ).Q;
    file["unitarydim="*string(Dims[i])]=states
end
close(file)
