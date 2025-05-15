# %%
import scipy.optimize as so
import numpy as np
import h5py as h5
    

# %%
def UFid(U,V,Dim):
#    return np.sum(abs(U-V)**2)
    return abs(np.trace(np.matmul(U.conj().T,V))/Dim)**2

# %%
def QuantumFourier(Dim): 
    pi=np.arccos(-1.)
    x=np.array(range(Dim))
    return np.exp( 1j*2*pi*np.reshape( np.kron(x,x), [Dim,Dim] )/Dim )/np.sqrt(Dim)

# %%
def RandomUnitary(Dim):
    return np.linalg.qr( np.random.randn(Dim,Dim)+1j*np.random.randn(Dim,Dim) )[0]

# %%
def UFunction(Phase,N,F,Dim):
    U=np.eye(Dim)
    for k in range(N):
        U= np.exp( 1j*np.append([0] ,Phase[k*(Dim-1):(k+1)*(Dim-1)] ) )[:,np.newaxis]*U
        U=np.matmul(F,U)
    return np.exp(1j*np.append( [0], Phase[N*(Dim-1):(N+1)*Dim-1]))[:,np.newaxis]*U

# %%
def PUMIOpt(F,Dim,N,U):
    Seed = np.ones( (N+1)*(Dim-1) )
    TargetOpt = lambda x: 1-UFid( U , UFunction( x , N , F , Dim ) , Dim )
    argsmin = {"method": "L-BFGS-B"}
    Res=so.basinhopping(TargetOpt , Seed,minimizer_kwargs=argsmin,niter=5*10**2,disp=True)
    return Res.fun

# %%
def main():
    Repe=100
    Dim=4
    N=Dim
    
    F = QuantumFourier(Dim)
    file=h5.File("FFdataDim=4.h5","r") # Cambiar Nombre archivo 
    UU=file["re"][:,:,:].T+1j*file["im"][:,:,:].T
    
    ind2=file["Index"][:]-1
    MC=len(ind2)
    file.close()
    Data=np.zeros([MC,Repe])
    l=np.where(Data[:,0]<1)
    print(Dim,"-----",MC)
    for j in range(Repe):
        for i in range(MC):
            Data[i,j]=PUMIOpt( F,Dim,N,UU[:,:,ind2[ l[0][i] ]] )
        l2=np.where(Data[l,j]<10**(-10))
        for h in range(np.size(l2[0])):
            Data[l2[0][h],:]=Data[l2[0][h],j]
        l=np.where(Data[:,j]>10**(-10))
        MC=np.size(l[0])
        print(j,"-----",np.size(l[0]))

    file=h5.File("FFdataDim=4py.h5","w") #Cambiar nombre al archivo de salida
    file["infi"]=Data
    file["index1"]=l[0]
    file["index2"]=l2[0]
    file.close()

# %%
from joblib import Parallel, delayed

# %%
infids_comparison = []

for Dim in range(3,4):

    L   = 0
    file=h5.File("data/HaarDistributed_Dim="+str(Dim)+"_Lay=Dim+"+str(L)+".h5","r")
    infids = np.min( file['infi'][:], axis=0 )
    file.close()

    N=Dim
    F=QuantumFourier(Dim)

    file=h5.File("HaarUnitary.h5","r")
    Us=file['unitarydim={}'.format(Dim)][:,:,:]
    file.close()

    idx_sort   = np.argsort( infids )[::-1][:10]

    N=Dim
    F=QuantumFourier(Dim)

    def par_fun( i ):
        U = Us[i,:,:]
        infi_julia = infids[i]
        infid_BH = PUMIOpt( F,Dim,N,U )
        return infi_julia,infid_BH

    infids_comparison.append( Parallel(n_jobs=8)( delayed(par_fun)(i) for i in idx_sort  ) )

    np.save( 'julia_vs_python', infids_comparison )

# %%



