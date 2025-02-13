using HDF5, LinearAlgebra

MC=1000;
file=h5open("HaarUnitary.h5","w");
Dims=collect(3:10);
DimN=size(Dims)[1];
file["dimensions"]=Dims
file["montecarlo"]=[MC]

@show MC

for i=1:DimN
    mat = randn(Dims[i],Dims[i],MC)+1im*randn(Dims[i],Dims[i],MC)
    for j=1:MC
        mat[:,:,j]= Matrix( qr( mat[:,:,j] ).Q )
    end
    file["unitarydim="*string(Dims[i])] = mat
end
close(file)
