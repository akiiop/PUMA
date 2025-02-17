using HDF5, LinearAlgebra

MC=5000 # Number of states that will be generated for each dimension

file=h5open("HaarStates.h5","w") # generated file containing the mats

Dims=collect(3:10) # Dimensions of the states
DimN=size(Dims)[1]

# Additional data that will be added to the .h5 file
# This data is necesary for the simulations programs to work
# unless the recronstuction program is modified
file["dimensions"]=Dims
file["montecarlo"]=[MC]

# Haar distributed states generation
for i=1:DimN
    
    z=randn(Dims[i],MC)+1im*randn(Dims[i],MC);
    states=z./sqrt.(sum(abs2.(z),dims=1))
    
    file["statesdim="*string(Dims[i])]=states # Mats index in the hdf5 file 
end
close(file)
