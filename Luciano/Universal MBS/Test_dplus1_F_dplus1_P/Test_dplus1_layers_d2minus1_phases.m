
MC = 1000;
%Data = cell(10,1);
load('Test_dplus1_F_P.mat')

for d=5:10
    
    Fid = nan(MC,3);
    Ues = nan(d,d,MC);
    Pos = zeros(d,d+2); Pos(2:end,1:end-1)=1;
    
    parfor k = 1:MC
        U=RandomUnitary(d);
        %U = Ues(:,:,k);
        [U_hat_v0,Fid_hat_v0]=Multiport_Decomposition(U,[],d,15);
        [U_hat_v1,Fid_hat_v1]=Multiport_Decomposition(U,[],d+1,15);
        [U_hat_v2,Fid_hat_v2]=Multiport_Decomposition_V2(U,[],d+1,15,[],[],Pos);
        Fid(k,:)=[Fid_hat_v0,Fid_hat_v1,Fid_hat_v2];
        Ues(:,:,k) = U;
    end
    
    Fid(Fid<=0) = eps;
    
    Data{d-2} = {Fid,Ues};
    save('Test_dplus1_F_P.mat','Data')
    
end

%%
% 
% Fmax = max(Fid(:));
% Fmin = min(Fid(:));
% 
% B = linspace(log10(Fmin),log10(Fmax),20);
% 
% histogram(log10(Fid(:,1)),B)
% hold on
% histogram(log10(Fid(:,2)),B)
% histogram(log10(Fid(:,3)),B)
% legend('3 layers, 9 phases','4 layers, 12 phases','4 layers, 9 phases')
% hold off

