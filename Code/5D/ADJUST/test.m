clc
clear all

myFolder = 'E:/Semester notes/Individual Research Project/Dataset_video';
baseFileName1 = 'LFVU_toy.mat';
baseFileName2 = 'LFVV_toy.mat';

bpp_mat = sprintf('%s/%s', myFolder ,baseFileName1);
psnr_mat = sprintf('%s/%s', myFolder ,baseFileName2);
load(bpp_mat);
A = lfv;
load(psnr_mat);
B = lfv;
clear lfv

tic
L = 1;
C1 = (0.01*L).^2;
C2 = (0.03*L).^2;

sum_ssim = 0;
count = 0;
for i=1:8
    for j=1:8
        for f=1:24
            A_s = im2double(squeeze(A(i,j,:,:,f)));
            B_s = im2double(squeeze(B(i,j,:,:,f)));
            
            uA = mean(A_s(:));
            uB = mean(B_s(:));
            S = cov(A_s,B_s);
            
            T1 = 2*uA*uB + C1;
            T2 = 2*S(1,2) + C2;
            T3 = uA^2 + uB^2 + C1;
            T4 = S(1,1) + S(2,2) + C2;
            
            ssimval = (T1*T2)/(T3*T4);
            sum_ssim = sum_ssim + ssimval;
            count = count + 1;
        end
    end
end
clear A_s
clear B_s
 
SSIM = sum_ssim/(8*8*24);
time = toc;


