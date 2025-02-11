
load('Test_dplus1_F_P.mat')


for d=3:10
    Fid = Data{d-2}{1};
    Fmax = max(Fid(:));
    Fmin = min(Fid(:));
    
    B = linspace(log10(Fmin),log10(Fmax),20);
    
    subplot(3,3,d-2)
    histogram(log10(Fid(:,1)),B)
    hold on
    histogram(log10(Fid(:,2)),B)
    histogram(log10(Fid(:,3)),B)
    hold off
end

hub = subplot(3,3,9);
histogram([nan])
hold on
histogram([nan])
histogram([nan])
hold off
set(hub,'Visible', 'off');
legend(['d layers,' newline 'd^2 phases'],['d+1 layes,' newline '(d-1)(d+2)+1 phases'],...
        ['d+1 layers,' newline 'd^2 phases'])

