using Distributed, MAT, HDF5
# Number of threads used for the parallelization, adjust according to hardware
addprocs(4)

@everywhere using LinearAlgebra, SharedArrays, Optim

@everywhere function RandomUnitary(Dim)
	return qr( randn(Dim,Dim)+1im*randn(Dim,Dim) ).Q;
end

function QuantumFourier(Dim)
	return [exp( 1im*2*pi*i*j/Dim )/sqrt(Dim) for i=0:Dim-1,j=0:Dim-1];
end

@everywhere function StateFunction(Phase,InState,F,Dim,N)
    U=InState
    for k=1:N
		@views U=exp.(1im*[0 ; Phase[1+(k-1)*(Dim-1):k*(Dim-1)]]).*U;
		U=F*U;
	end
	return exp.(1im*[0 ; Phase[N*(Dim-1)+1:end]]).*U;
end

@everywhere function Fid(InState,Output,Dim)
	return abs2(dot(InState,Output));
end

@everywhere function PUMIOpt(F,Dim,InState,Output,N)
	Seed = pi*randn( (N+1)*(Dim-1) );
	TargetOpt(x) = 1 - Fid( Output , StateFunction( x , InState, F , Dim , N) , Dim );
	Res=Optim.minimizer( optimize( TargetOpt , Seed , LBFGS() ) );
	return TargetOpt(Res);
end

function main()
    # Number of times the optimization is carried for every individual state
    # In post-analisis the minimum is selected 
    Repe = 20;
    
    # Loading the states that will be reconstructed
    # the .h5 file needs to be prepared before hand
    file=h5open("HaarStates.h5","r"); # Loading the file containing the states
    Dims=file["dimensions"][:];
	MC=file["montecarlo"][1][1];
    DimN=size(Dims[1:end])[1];
    
	Data=SharedArray{Float64}(DimN,MC,Repe);
    
    @show Repe, MC

	for h=1:DimN;        
		Dim=Dims[h]
        
        # Number of layers
        # Needs to be changed manually in case of optimizing differen number of layers 
        N=4 
        
        OutStates=file["statesdim="*string(Dim)][:,:]
        
        F = QuantumFourier(Dim);
        
        @show Dim, N
        
        # Initial state of the circuits
        # always starts as the 0 state
        InState=Matrix{Complex{Float64}}(I,Dim,Dim)[1,:];

		@time @sync @distributed for i=1:MC
			@views State=OutStates[:,i];
			for j=1:Repe
				Data[h,i,j]=PUMIOpt(F,Dim,InState,State,N);
			end
		end
        
        # Data storage destination
		file2=h5open("data/DataStatesDim="*string(Dim)*"Lay="*string(N)*".h5","w");
		file2["infi"]=Data[h,:,:];
		close(file2)
	end
    close(file)
end

main()
