
load('data_contraejemplos.mat')
Rep = 30;

for k=4:8
    d = k+2;
    Fids = data_contraejemplos{d-2}{2}(:,1);
    [fid,Indx] = max(Fids);
    U = data_contraejemplos{d-2}{1}(:,:,Indx);
    count = 0;
        
    for l = 1:Rep
        if mod(l,2)==1
            [a,b,c] = Multiport_Decomposition(U,[],[],4,'MS');
        else
            [a,b,c] = Multiport_Decomposition(U,[],[],4,'MGS');
        end
        if b < fid
            Fids(Indx) = b;
            [fid,Indx] = max(Fids);
            U = data_contraejemplos{d-2}{1}(:,:,Indx);
            count = 0;
        else
            count = count+1;
        end
    end
    [d,count,fid] 
    
    data_contraejemplos{d-2}{2}(:,1) = Fids;
    save('data_contraejemplos.mat','data_contraejemplos')
end



