# Introduction
Repository for the simulations and data of the article [Minimum optical depth multi-port interferometers for approximating any unitary transformation and any pure state](https://doi.org/10.48550/arXiv.2002.01371). Within this repository all data files and programs necessary to recreate the histograms for the article can be found, meaning:

- The States and Unitary Transformations recreated can be found as `.HDf5` or `.mat` files in the respective folders.
- The programs that performed the optimization.
- The data of the optimized phases for the PUMA's configutations.
- The plotting programs.


# Pure States

`PureStateReconstructor.jl` is the program that generates the data, i.e, is the program that optimizes the phases for a PUMA configuration given the states are provided with a HDF5 file named `HaarStates.h5`. This HDF5 can be generated using the program `Haar_Generator.jl` (Refer to this file in doubt of what the `HaarStates.h5` needs to contain). The data after running `PureStateReconstructor.jl` is stored in the `data` folder.

The plotting program is in the `PlottingPureStates.ipynb` notebook, it works on it own and just need compiling. The article plot should be named `PureStatesHist.pdf`.

# Unitary Transformations

## Block Diagonal

`BlockDiagReconstructor.jl` is the program that generates the data, i.e, is the program that optimizes the phases for a PUMA configuration given the states are provided with a HDF5 file named `data_contraejemplos.mat`. The data after running `BlockDiagReconstructor.jl` is stored in the `data` folder.


The plotting program is in the `PlottingBlockDiag.ipynb` notebook, it works on it own and just need compiling. The article plot should be named `BlockDiagHist.pdf`.

## Haar Distributed

`HaarUnitaryReconstructor.jl` is the program that generates the data, i.e, is the program that optimizes the phases for a PUMA configuration given the states are provided with a HDF5 file named `HaarUnitary.h5`. This HDF5 can be generated using the program `Unitary_Haar_Generator.jl` (Refer to this file in doubt of what the `HaarUnitary.h5` needs to contain). The data after running `HaarUnitaryReconstructor.jl` is stored in the `data` folder.

The plotting program is in the `PlottingHaar.ipynb` notebook, it works on it own and just need compiling. The article plot should be named `HaarDistrHist.pdf`.
