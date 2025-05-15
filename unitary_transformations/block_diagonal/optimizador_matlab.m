

load('data_contraejemplos.mat')
infids_comparison = NaN(8,100,2);

for d = 3:3

    L = 0;
    infids = data_contraejemplos{d-2}{2}(:,1);
    [ infids_sort, index_sort ] = sort( infids,  'descend' );
    UUs = data_contraejemplos{d-2}{1};
    
    infids_temp = NaN(100,2);
    parfor i = 1:4
        UU = UUs(:,:,i)
        [~,b]=Multiport_Decomposition(UU,[],[],10,'MGS');
        infids_temp(i,:) = [ infids(i), b ];
    end
    
    infids_comparison(d-2,:,:) = infids_temp;

    %save( 'Julia_vs_matlab.mat', "infids_comparison" )
    
end


