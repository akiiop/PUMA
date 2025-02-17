# Pure States

`PureStateReconstructor.jl` is the program that generates the data, i.e, is the program that optimizes the phases for a PUMA configuration given the states are provided with a HDF5 file named `HaarStates.h5`. This HDF5 can be generated using the program `Haar_Generator.jl` (Refer to this file in doubt of what the `HaarStates.h5` needs to contain). The data after running `PureStateReconstructor.jl` is stored in the `data` folder.

Data is in the data.tar.gz, needs to be extracted to plot it (Extracted to a folder named `data` ). The plotting program is in the `PlottingPureStates` notebook, it works on it own and just need compiling. The article plot should be named `PureStatesHist.pdf`.

# Unitary Transformations

## Block Diagonal

`PureStateReconstructor.jl` is the program that generates the data, i.e, is the program that optimizes the phases for a PUMA configuration given the states are provided with a HDF5 file named `HaarStates.h5`. This HDF5 can be generated using the program `Haar_Generator.jl`.

The plotting program is in the `PlottingBlockDiag` notebook, it works on it own and just need compiling. The article plot should be named `BlockDiagHist.pdf`.

## Haar Distributed

The plotting program is in the `PlottingHaar` notebook, it works on it own and just need compiling. The article plot should be named `HaarDistrHist.pdf`.
