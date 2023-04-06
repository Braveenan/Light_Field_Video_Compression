function [PSNR,SSIM] = compareQuality(FileName, in_folder)
% Compare the quality of the images currently in PNG_Format to
% a dataset located in variable 'folder'

PSNR = zeros(8,8);
SSIM = zeros(8,8);

%% Read in the image data and if necessary also clip the edges to fit
% test = im2double(imread(sprintf('C:/Users/Namalka/OneDrive - UNSW/ICS/%s/002_002.ppm', REF_folder)));
% [A_height, A_width, A_comps] = size(test);
% A_height = A_height - mod(A_height, 8);
% A_width = A_width - mod(A_width, 8);
% A = zeros(8,8,A_height,A_width,A_comps);

%% Read in the decompressed image data
load(FileName);
for i = 1:8
    for j = 1:8
        REF_image=im2double(squeeze(LF(i,j,:,:,:)));
        [height, width, ~] = size(REF_image);
        height = height - mod(height, 8);
        width = width - mod(width, 8);
        REF_image = REF_image(1:height,1:width,:);
        A(i ,j ,:,:,:) = REF_image;
    end
end

%% Calculate PSNR and SSIM from these two data sets
for i = 1:8
    for j = 1:8
        B = im2double(imread(sprintf('C:/Users/Namalka/OneDrive - UNSW/ICS/%s/%d_%d.png', in_folder, i, j)));
        [height, width, n_comps] = size(B);
        height = height - mod(height, 8);
        width = width - mod(width, 8);
        B = B(1:height, 1:width, :);
        PSNR(i,j) = psnr(B, squeeze(A(i,j,:,:,:)));
        SSIM(i,j) = ssim(B, squeeze(A(i,j,:,:,:)));
    end
end

%% Output data
avg_psnr = sum(sum(PSNR))/64
avg_ssim = sum(sum(SSIM))/64

% fileID = fopen(sprintf('%s/metadata.txt', in_folder), 'wt');
% fprintf(fileID, 'Average PSNR is %f\n', avg_psnr);
% fprintf(fileID, 'Average SSIM is %f\n', avg_ssim);
% fclose(fileID);
end