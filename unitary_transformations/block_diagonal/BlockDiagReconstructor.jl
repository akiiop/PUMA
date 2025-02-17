using Distributed, SharedArrays, MAT
# Number of threads used for the parallelization, adjust according to hardware
addprocs(10)

@everywhere using LinearAlgebra, Optim

@everywhere function RandomUnitary(Dim)
	return qr( randn(Dim,Dim)+1im*randn(Dim,Dim) ).Q;
end

function QuantumFourier(Dim)
	return [exp( 1im*2*pi*i*j/Dim )/sqrt(Dim) for i=0:Dim-1,j=0:Dim-1];
end 

@everywhere function UFunction(Phase,N,F,Dim)
	U=Matrix{Complex{Float64}}(I,Dim,Dim);
	for k=1:N
		@views U=exp.(1im*[0 ; Phase[1+(k-1)*(Dim-1):k*(Dim-1)]]).*U;
		U=F*U;
	end
	return exp.(1im*[0 ; Phase[N*(Dim-1)+1:end]]).*U;
end

@everywhere function UFid(U,V,Dim)
	return abs2(tr(U'*V)/Dim);
end

@everywhere function PUMIOpt(F,Dim,N,U)
	Seed = pi*randn( (N+1)*(Dim-1) );
	TargetOpt(x) = 1 - UFid( U , UFunction( x , N , F , Dim ) , Dim );
	Res=Optim.minimizer( optimize( TargetOpt , Seed , LBFGS() ) );
	return TargetOpt(Res);
end

function main()
    # Number of times the optimization is carried for every individual matrix
    # In post-analisis the minimum is selected 
    Repe = 30
    
    # Loading the states that will be reconstructed
    # the .mat file needs to be prepared before hand
    # Loading the file containing the mats
	Matrices=matread("data_contraejemplos.mat")["data_contraejemplos"] # Loading the file containing the mats
	DimN=size(Matrices)[2];
	MC=size(Matrices[1][1])[3];
    
	Data=SharedArray{Float64}(DimN,MC,Repe);
    
    @show Repe, MC
    
	for h=1:DimN
        
        Dim=2+h
        
        # N is the Number of layers
        # Needs to be changed manually in case of optimizing differen number of layers 
        # Program uses L to save the files as Lay=Dim+L
        # Change L to in order to test differents layers 
        L=1
        N=Dim+L;
        
        UU=Matrices[h][1];
		F = QuantumFourier(Dim);
        
        @show Dim, N

		@time @sync @distributed for i=1:MC
			U=UU[:,:,i];
			for j=1:Repe
				Data[h,i,j]=PUMIOpt(F,Dim,N,U);
			end
		end

        # Data storage destination
        file=matopen("data/lucianodata_Dim="*string(Dim)*"_Lay=Dim+"*string(L)*".mat","w")
        write(file,"infi",Data[h,:,:])
        close(file)
	end
# 	file=matopen("lucianodata.mat","w")
# 	write(file,"infi",Data)
# 	close(file)
end 

main()
