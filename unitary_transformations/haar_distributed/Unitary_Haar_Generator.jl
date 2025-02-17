using HDF5, LinearAlgebra

MC=1000; # Number of mats that will be generated for each dimension

file=h5open("HaarUnitary.h5","w"); # generated file containing the mats

Dims=collect(3:10) # Dimensions of the mats
DimN=size(Dims)[1]

# Additional data that will be added to the .h5 file
# This data is necesary for the simulations programs to work
# unless the recronstuction program is modified
file["dimensions"]=Dims
file["montecarlo"]=[MC]

# Haar distributed unitary transfornations generation
for i=1:DimN
    mat = randn(Dims[i],Dims[i],MC)+1im*randn(Dims[i],Dims[i],MC)
    
    for j=1:MC
        mat[:,:,j]= Matrix( qr( mat[:,:,j] ).Q )
    end
    
    file["unitarydim="*string(Dims[i])] = mat # Mats index in the hdf5 file 
end

close(file)
