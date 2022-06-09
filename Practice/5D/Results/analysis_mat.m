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
c = 3;

for t = 1:7
    bpp_arr = transpose(squeeze(LFV_bpp(d,c,t,:)));
    psnr_arr = transpose(squeeze(LFV_psnr(d,c,t,:)));
    
    plot(bpp_arr,psnr_arr,'-o')
    hold on
end

legend('True', 'BAS 2008', 'BAS 2011 parameter 0', 'BAS 2011 parameter 1', 'CB 2011', 'Modified CB 2011', 'Proposed')
legend('Location','best')

xlabel('bpp')
ylabel('PSNR')

d_name = string(dataset_array(d));
c_name = string(channel_array(c));
g_title = sprintf('%s %s',c_name,d_name);
title(g_title)
