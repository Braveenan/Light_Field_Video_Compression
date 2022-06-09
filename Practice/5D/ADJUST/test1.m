clc
clear all

myFolder = 'E:/Semester notes/Individual Research Project/Dataset_video';
baseFileName1 = 'LFVY_toy.mat';
baseFileName2 = 'LFVY_david.mat';

bpp_mat = sprintf('%s/%s', myFolder ,baseFileName1);
psnr_mat = sprintf('%s/%s', myFolder ,baseFileName2);
load(bpp_mat);
A = lfv;
load(psnr_mat);
B = lfv;
clear lfv

tic;
sum_ssim = 0;
for i=1:8
    for j=1:8
        for f=1:24
            A_s = squeeze(A(i,j,:,:,f));
            B_s = squeeze(B(i,j,:,:,f));
            ssim_val = ssim(A_s,B_s);
            sum_ssim = sum_ssim+ssim_val;
        end 
    end 
end 
SSIM = sum_ssim/(8*8*24);
time = toc;

