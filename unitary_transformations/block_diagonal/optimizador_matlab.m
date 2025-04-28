

load('data_contraejemplos.mat')
infids_comparison = NaN(8,2);

parfor d = 3:10

    L = 0;
    infids = data_contraejemplos{d-2}{2}(:,1)
    infids_min = min( infids.' );
    [infid_worst, index_worst] = max( infids_min );
    
    UUs = data_contraejemplos{d-2}{1}(:,:,index_worst)
        
    [~,b]=Multiport_Decomposition(UUs(:,:,index_worst),[],[],10,'MGS');
    infid_matlab = b;
    
    infids_comparison(d-2,:) = [ infid_worst , infid_matlab ]
    
end

save( 'Julia_vs_matlab.mat', "infids_comparison" )
