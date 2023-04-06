clc
clear all

myFolder = 'E:/Semester notes/Individual Research Project/Practice/5D/Results';
baseFileName1 = 'LFV_bpp.mat';
baseFileName2 = 'LFV_psnr.mat';
baseFileName3 = 'LFV_enr.mat';
baseFileName4 = 'LFV_ssim.mat';

bpp_mat = sprintf('%s/%s', myFolder ,baseFileName1);
psnr_mat = sprintf('%s/%s', myFolder ,baseFileName2);
enr_mat = sprintf('%s/%s', myFolder ,baseFileName3);
ssim_mat = sprintf('%s/%s', myFolder ,baseFileName4);

load(bpp_mat);
load(psnr_mat);
load(enr_mat);
load(ssim_mat);

dataset_array = {'Dataset1 - Car', 'Dataset2 - David', 'Dataset3 - Toy'};
channel_array = {'LFVU', 'LFVV', 'LFVY'};
dcttype_array = {'Exact DCT', 'BAS 2008', 'BAS 2011 parameter 0', 'BAS 2011 parameter 1', 'CB 2011', 'Modified CB 2011', 'PMC 2014'};
qval_array = [1, 3, 5, 7, 10, 15, 25, 35, 50, 80, 100, 120, 150, 180, 200];

fileID = fopen(sprintf('qval.txt'), 'wt');
sumpsnr = 0;
sumssim = 0;
for k = 1:15
    fprintf(fileID, 'qval: %d\n', qval_array(k));
    fprintf(fileID, 'bpp: %d\n', LFV_bpp(2,3,1,k));
    fprintf(fileID, 'psnr: %d\n', LFV_psnr(2,3,1,k));
    fprintf(fileID, 'ssim: %d\n', LFV_ssim(2,3,1,k));
    fprintf(fileID, 'enr: %d\n\n', LFV_enr(2,3,1,k));
    
    sumpsnr = sumpsnr+LFV_psnr(2,3,1,k);
    sumssim = sumssim+LFV_ssim(2,3,1,k);
end 

fprintf(fileID, 'avaerage psnr: %d\n', sumpsnr/15);
fprintf(fileID, 'average ssim: %d\n\n', sumssim/15);
