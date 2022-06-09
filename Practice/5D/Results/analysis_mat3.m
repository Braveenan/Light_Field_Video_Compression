clc
clear all

myFolder = 'E:/Semester notes/Individual Research Project/Practice/5D/Results';
baseFileName1 = 'LFV_bpp.mat';
baseFileName2 = 'LFV_psnr.mat';

bpp_mat = sprintf('%s/%s', myFolder ,baseFileName1);
psnr_mat = sprintf('%s/%s', myFolder ,baseFileName2);
load(bpp_mat);
load(psnr_mat);

dataset_array = {'car', 'david', 'toy'};
channel_array = {'LFVU', 'LFVV', 'LFVY'};
dcttype_arrat = {'True', 'BAS 2008', 'BAS 2011 parameter 0', 'BAS 2011 parameter 1', 'CB 2011', 'Modified CB 2011', 'Proposed'};
qval_array = [1, 3, 5, 7, 10, 15, 25, 35, 50, 80, 100, 120, 150, 180, 200];

d = 3;
for t = 1:7
    bpp_arr = (transpose(squeeze(LFV_bpp(d,1,t,3:15)))+transpose(squeeze(LFV_bpp(d,2,t,3:15)))+4*transpose(squeeze(LFV_bpp(d,3,t,3:15))))/6;
    for i = 1:13
        bpp_arr_log(i) = log(bpp_arr(i));
    end 
    psnr_arr = (transpose(squeeze(LFV_psnr(d,1,t,3:15)))+transpose(squeeze(LFV_psnr(d,2,t,3:15)))+6*transpose(squeeze(LFV_psnr(d,3,t,3:15))))/8;
    
    grid on
    plot(bpp_arr_log,psnr_arr,'-o')
    hold on
end

legend('True', 'BAS 2008', 'BAS 2011 parameter 0', 'BAS 2011 parameter 1', 'CB 2011', 'Modified CB 2011', 'Proposed')
legend('Location','best')

xlabel('bpp(log)')
ylabel('PSNR')

d_name = string(dataset_array(d));
g_title = sprintf('%s in log scale',d_name);
title(g_title)
