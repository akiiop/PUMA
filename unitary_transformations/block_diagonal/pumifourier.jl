using Distributed, SharedArrays, MAT

addprocs(20)
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
    Repe = 5
	Matrices=matread("data_contraejemplos.mat")["data_contraejemplos"];
	DimN=size(Matrices)[2];
	MC=size(Matrices[1][1])[3];
	Data=SharedArray{Float64}(DimN,MC,Repe);
	
	for h=1:DimN;
		Dim=2+h;
		N=Dim+2;
		UU=Matrices[h][1];
		F = QuantumFourier(Dim);
        println("hola","lays="*String(N),"MC="* String( MC) );
		println(Dim)
		@time @sync @distributed for i=1:MC
			U=UU[:,:,i];
			for j=1:Repe
				Data[h,i,j]=PUMIOpt(F,Dim,N,U);
			end
		end
		file=matopen("data/lucianodata_Dim="*string(Dim)*"_Lay="*string(N)*".mat","w")
		write(file,"infi",Data[h,:,:])
		close(file)
	end
# 	file=matopen("lucianodata.mat","w")
# 	write(file,"infi",Data)
# 	close(file)
end 

main()
