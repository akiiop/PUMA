tic

load('data_contraejemplos.mat')
Rep = 200;

for d=[10,8,7]
    k = d-2;
    
    for l = 1:Rep
        [d,l]
        Indx = randi(1000);
        U = data_contraejemplos{d-2}{1}(:,:,Indx);
        fid = data_contraejemplos{d-2}{2}(Indx,1);
        [a,b,c] = Multiport_Decomposition(U,[],[],8,'MS');
        if b < fid
            data_contraejemplos{d-2}{2}(Indx,1) = b;
        end
    end
    save('data_contraejemplos.mat','data_contraejemplos')
    
end

toc