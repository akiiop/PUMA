# Introduction
Repository for the simulations and data of the article [Minimum optical depth multi-port interferometers for approximating any unitary transformation and any pure state](https://doi.org/10.48550/arXiv.2002.01371). Within this repository, all data files and programs necessary to recreate the histograms for the article can be found, meaning:

- States and Unitary Transformations recreated can be found as `.HDf5` or `.mat` files in the respective folders.
- Programs that performed the optimization with Julia.
- Programs that performed the optimization with Python BasinHopping and Matlab Global Search, to validate the results with Julia.
- Data of the optimized phases for the PUMA's configurations.
- Plotting programs.


# Pure States

`PureStateReconstructor.jl` is the program that generates the data, i.e., it optimizes the phases for a PUMA configuration given that the target states are provided with an HDF5 file named `HaarStates.h5`. This HDF5 can be generated using the program `Haar_Generator.jl` (Refer to this file if you are unsure of what the `HaarStates.h5` needs to contain). The data after running `PureStateReconstructor.jl` is stored in the `data` folder.

The plotting program is in the `PlottingPureStates.ipynb` notebook. It works on its own and just needs compiling. The article plot should be named `PureStatesHist.pdf`.

# Unitary Transformations

## Block Diagonal

`BlockDiagReconstructor.jl` is the program that generates the data. It optimizes the phases for a PUMA configuration, given that the target unitary transformations are provided with an HDF5 file named `data_contraejemplos.mat`. The data after running `BlockDiagReconstructor.jl` is stored in the `data` folder.


The plotting program is in the `PlottingBlockDiag.ipynb` notebook. It works on its own and just needs compiling. The article plot should be named `BlockDiagHist.pdf`.

## Haar Distributed

`HaarUnitaryReconstructor.jl` is the program that generates the data, i.e, is the program that optimizes the phases for a PUMA configuration given the target unitary transformations are provided with an HDF5 file named `HaarUnitary.h5`. This HDF5 can be generated using the program `Unitary_Haar_Generator.jl` (Refer to this file in doubt of what the `HaarUnitary.h5` needs to contain). The data after running `HaarUnitaryReconstructor.jl` is stored in the `data` folder.

The plotting program is in the `PlottingHaar.ipynb` notebook. It works on its own and just needs compiling. The article plot should be named `HaarDistrHist.pdf`.

For both Haar distributed and Block diagonal, the notebooks `Julia_vs_python_vs_matlabs.ipynb` display the comparison between Julia Optim, Python BasinHopping, and Matlab GlobalSearch. 