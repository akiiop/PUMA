
infids_comparison = NaN(8,2);

parfor d = 3:10

    L = 0;
    infids = h5read("data/HaarDistributed_Dim="+string(d)+"_Lay=Dim+"+string(L)+".h5", '/infi');
    infids_min = min( infids.' );
    [infid_worst, index_worst] = max( infids_min );
    
    UU = h5read("HaarUnitary.h5",'/unitarydim='+string(d));
    UUs = UU.r + 1i*UU.i;
        
    [~,b]=Multiport_Decomposition(UUs(:,:,index_worst),[],[],10,'MGS');
    infid_matlab = b;
    
    infids_comparison(d-2,:) = [ infid_worst , infid_matlab ]
    
end

save( 'Julia_vs_matlab.mat', "infids_comparison" )
