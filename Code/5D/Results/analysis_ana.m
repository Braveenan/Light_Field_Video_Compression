clc
clear all

myFolder = 'E:/Semester notes/Individual Research Project/Practice/5D/Results';
baseFileName1 = 'LFV_bpp_ana.mat';
baseFileName2 = 'LFV_psnr_ana.mat';
baseFileName3 = 'LFV_ssim_ana.mat';

bpp_mat = sprintf('%s/%s', myFolder ,baseFileName1);
psnr_mat = sprintf('%s/%s', myFolder ,baseFileName2);
ssim_mat = sprintf('%s/%s', myFolder ,baseFileName3);

load(bpp_mat);
load(psnr_mat);
load(ssim_mat);

dctapp_array = {'Original', 'intra-view', 'inter-view'};
channel_array = {'LFVU', 'LFVV', 'LFVY'};
qval_array = [1, 3, 5, 7, 10, 15, 25, 35, 50, 80, 100, 120, 150, 180, 200];

subplot(1,2,1)
for d = 1:3
    bpp_arr = (transpose(squeeze(LFV_bpp(d,1,3:15)))+transpose(squeeze(LFV_bpp(d,2,3:15)))+4*transpose(squeeze(LFV_bpp(d,3,3:15))))/6;
    psnr_arr = (transpose(squeeze(LFV_psnr(d,1,3:15)))+transpose(squeeze(LFV_psnr(d,2,3:15)))+6*transpose(squeeze(LFV_psnr(d,3,3:15))))/8;
        

    plot(bpp_arr,psnr_arr,'-o')
    hold on
end  
axis([0 0.4 38 56]);
legend('5D ADCT 8󭅌󭅌', '3D ADCT 1󪻘󭅌 (intra-view+temporal)', '3D ADCT 8󭅅󪻘 (inter-view+temporal)')
legend('Location','southeast')
grid on
xlabel('Compression rate [bpp]')
ylabel('PSNR [dB]')
title('(a)')

subplot(1,2,2)
for d = 1:3
    bpp_arr = (transpose(squeeze(LFV_bpp(d,1,3:15)))+transpose(squeeze(LFV_bpp(d,2,3:15)))+4*transpose(squeeze(LFV_bpp(d,3,3:15))))/6;
    ssim_arr = transpose(squeeze(LFV_ssim(d,3,3:15)));
        

    plot(bpp_arr,ssim_arr,'-o')
    hold on
end  
axis([0 0.4 0.88 1]);
legend('5D ADCT 8󭅌󭅌', '3D ADCT 1󪻘󭅌 (intra-view)', '3D ADCT 8󭅅󪻘 (inter-view)')
legend('Location','southeast')
grid on
xlabel('Compression rate [bpp]')
ylabel('SSIM')
title('(b)')
    







