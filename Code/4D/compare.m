function [PSNR,SSIM] = compare(A, B)
% Compare original light field A with reconstructed light field B

PSNR = zeros(8,8);
SSIM = zeros(8,8);

% Calculate PSNR and SSIM from these two data sets
tic;
for i = 1:8
    for j = 1:8
        PSNR(i,j) = psnr(squeeze(B(i,j,:,:,:)), squeeze(A(i,j,:,:,:)));
        SSIM(i,j) = ssim(squeeze(B(i,j,:,:,:)), squeeze(A(i,j,:,:,:)));
    end
end
cal_time = toc