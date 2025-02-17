using Distributed, HDF5

addprocs(10)
@everywhere using LinearAlgebra, SharedArrays, Optim

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
    
    Repe = 30
    
    file = h5open("HaarUnitary.h5","r")
    MC = file["montecarlo"][1]
    Dims = file["dimensions"][:]
    DimN=size(Dims)[1]
    
    Data=SharedArray{Float64}(DimN,MC,Repe)
    
    @show Repe,MC

    for (h,Dim) in enumerate(Dims)
        
        L=1
        N=Dim+L
        UU = file["unitarydim="*string(Dim)][:,:,:]
        F = QuantumFourier(Dim)
        
        @show N,Dim
        
        @time @sync @distributed for i=1:MC
            
            U=UU[:,:,i];
            
            for j=1:Repe
                Data[h,i,j]=PUMIOpt(F,Dim,N,U);
            end
        
        end
        
        datasave = h5open("data/HaarDistributed_Dim="*string(Dim)*"_Lay=Dim+"*string(L)*".h5","w")
        datasave["infi"]= Data[h,:,:]
        close(datasave)

    end
    
    close(file)
    
end 


main()
