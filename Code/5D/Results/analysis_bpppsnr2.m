clc
clear all

myFolder = 'E:/Semester notes/Individual Research Project/Practice/5D/Results';
baseFileName1 = 'LFV_bpp.mat';
baseFileName2 = 'LFV_psnr.mat';

bpp_mat = sprintf('%s/%s', myFolder ,baseFileName1);
psnr_mat = sprintf('%s/%s', myFolder ,baseFileName2);

load(bpp_mat);
load(psnr_mat);

dataset_array = {'(a) Car', '(b) David', '(c) Toy'};
channel_array = {'LFVU', 'LFVV', 'LFVY'};
dcttype_array = {'Exact DCT', 'BAS 2008', 'BAS 2011 parameter 0', 'BAS 2011 parameter 1', 'CB 2011', 'Modified CB 2011', 'PMC 2014'};
qval_array = [1, 3, 5, 7, 10, 15, 25, 35, 50, 80, 100, 120, 150, 180, 200];

for d=1:3
    subplot(1,3,d)
        
    for t = 1:7
        bpp_arr = (transpose(squeeze(LFV_bpp(d,1,t,3:15)))+transpose(squeeze(LFV_bpp(d,2,t,3:15)))+4*transpose(squeeze(LFV_bpp(d,3,t,3:15))))/6;
        psnr_arr = (transpose(squeeze(LFV_psnr(d,1,t,3:15)))+transpose(squeeze(LFV_psnr(d,2,t,3:15)))+6*transpose(squeeze(LFV_psnr(d,3,t,3:15))))/8;
        

        plot(bpp_arr,psnr_arr,'-o')
        hold on
    end
    
    if d==2
        axis([0 0.4 38 56]);
    else 
        axis([0 0.8 38 56]);
    end 
    
    legend('Exact DCT', 'BAS 2008', 'BAS 2011 parameter 0', 'BAS 2011 parameter 1', 'CB 2011', 'Modified CB 2011', 'PMC 2014')
    legend('Location','southeast')
    grid on
    xlabel('Compression rate [bpp]')
    ylabel('PSNR [dB]')
    
    d_name = string(dataset_array(d));
    g_title = sprintf('%s',d_name);
    title(g_title)
end 






