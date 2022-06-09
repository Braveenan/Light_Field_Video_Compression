function [PSNR] = compare(A, B, n_frames, no_of_pixels)

% Calculate squared error for these two data sets
sum_serr = 0; 
for (frame = 1:n_frames)
    A_s = squeeze(A(frame,:,:,:,:));
    B_s = squeeze(B(frame,:,:,:,:));
    
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


end 