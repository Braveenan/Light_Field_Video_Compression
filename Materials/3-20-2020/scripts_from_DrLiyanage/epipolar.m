% This is the main function for compression code
% Authored by Angus Blake
% 

clear;
clc;

fprintf('Beginning compression script\n');
fprintf('Enter the name of the folder that contains the data to be compressed\n');
folder_name = input('Folder name: ', 's');
%power_retained = input('Enter % power of signal to be retained: ');
DCT_Type = input('Approx or true DCT (1 = approx, 2 = true): ');

%% Read in all input images
load(sprintf('C:/Users/Namalka/OneDrive - UNSW/ICS/%s/LF.mat', folder_name));
totalEnergy = sum(abs(LF(:)));
for i = 1:8
    for j = 1:8
        % Populate array A with compressed versions of the input images
        %new_image = im2double(imread(sprintf('%s/00%d_00%d.ppm', folder_name, i, j)));
        new_image=im2double(squeeze(LF(i,j,:,:,:)));
        [height, width, n_comps] = size(new_image);
        height = height - mod(height, 8);
        width = width - mod(width, 8);
        new_image = new_image(1:height,1:width,:);
        A(i ,j ,:,:,:) = new_image;
    end
end
A=(A*255)-128;

%% Save the original data raw for comparison
%mkdir(sprintf('%s-original-raw', folder_name));
%save(sprintf('%s-original-raw/raw', folder_name), 'A');
%name = sprintf('%s-original', folder_name);
%lightFieldToPNG(A, name);

%% Select the ADCT or DCT matrix
if (DCT_Type == 1)
    T1 = [1,1,1,1,1,1,1,1;0,1,0,0,0,0,-1,0;1,0,0,-1,-1,0,0,1;1,0,0,0,0,0,0,-1;1,-1,-1,1,1,-1,-1,1;0,0,0,1,-1,0,0,0;0,-1,1,0,0,1,-1,0;0,0,1,0,0,-1,0,0];
    D = diag([1/sqrt(8), 1/sqrt(2), 1/2, 1/sqrt(2), 1/sqrt(8), 1/sqrt(2), 1/2, 1/sqrt(2)]);
    T = D*T1;
end
if (DCT_Type == 2)
    T = dctmtx(8);
end
Tinv = T';

%% Perform the epipolar compression script here
tic;
A = epi_compress(A, T, Tinv, 1);
toc;

%%Percentage of coeficients set to zero
B=uint8(A);
num_zero=nnz(~B);
zero_percent=(num_zero/(8*8*432*624*3))*100

suffix = sprintf('_epi_encode_%d', DCT_Type);

mkdir(sprintf('%s%s', folder_name, suffix));
save(sprintf('%s%s/compressed', folder_name, suffix), 'B');

%% Perform the inverse epipolar compression script here
T = Tinv;
Tinv = Tinv';

A = epi_compress(A, T, Tinv, 0);
A=uint8(A+128);

%% Energy Retined
totalEnergy2 = sum(abs(A(:)));
Energy_ret=(totalEnergy2/totalEnergy)*100


suffix = sprintf('_epi_decode_%d', DCT_Type);

%mkdir(sprintf('%s%s', folder_name, suffix));
%save(sprintf('%s%s/compressed', folder_name, suffix), 'A');

%% Save the decompressed file out as an image set
if (DCT_Type == 1) 
    name = sprintf('%s-epipolar-ADCT', folder_name);
end
if (DCT_Type == 2)
    name = sprintf('%s-epipolar-DCT', folder_name);
end
lightFieldToPNG(A, name);

%% Also check the image metrics for quality
[psnr,ssim]=compareQuality(folder_name, name);