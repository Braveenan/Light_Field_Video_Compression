function [PSNR, SSIM] = compare(A, B, n_frames, no_of_pixels)

% Calculate squared error for these two data sets
sum_serr = 0;
for (frame = 1:n_frames)
    A_s = squeeze(A(:,:,:,:,frame));
    B_s = squeeze(B(:,:,:,:,frame));
    
    serr = (A_s(:)-B_s(:)).^2;
    sum_serr = sum_serr + sum(serr);
end 

clear A_s
clear B_s
clear serr

% Calculate mean squared error for these two data sets
MSE = sum_serr/no_of_pixels;

% Calculate PSNR for these two data sets
PSNR = 10*log10(255^2/MSE);

% Calculate SSIM for these two data sets
sum_ssim = 0;
for x = 1:8
    for y = 1:8
        for f = 1:n_frames
            A_s = squeeze(A(x,y,:,:,f));
            B_s = squeeze(B(x,y,:,:,f));

            ssimval = ssim(A_s,B_s);
            sum_ssim = sum_ssim + ssimval;
        end 
    end 
end 

clear A_s
clear B_s 
SSIM = sum_ssim/(64*n_frames);


end 