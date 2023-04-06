% This is the main function for compression code

clear;clc;

fprintf('Beginning compression script\n');
fprintf('Enter the name of the folder that contains the data to be compressed\n');
folder_name = input('Folder name: ', 's');
DCT_Type = input('Approx or true DCT (1 = approx, 2 = true): ');

%% Read in the input dataset to array A for future processing
myFolder = sprintf('C:/Users/Namalka/OneDrive - UNSW/ICS/%s', folder_name);
if ~isdir(myFolder)
errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
uiwait(warndlg(errorMessage));
return;
end
filePattern = fullfile(myFolder, '*.mat');
matFiles = dir(filePattern);

fileID = fopen(sprintf('%s/metadata.txt', myFolder), 'wt');%OpenFile to write all data

Table={};
for k = 1:length(matFiles)
baseFileName = matFiles(k).name;
fullFileName = fullfile(myFolder, baseFileName);

fprintf(1, 'Now reading %s\n', fullFileName);
fprintf(fileID, 'Now reading: %s\n', fullFileName);
Table(15*(k-1)+1,1)={baseFileName};
load(fullFileName);

s1=dir(sprintf('%s/%s', folder_name ,baseFileName));
fprintf(fileID, 'Input LF size: %.2f MB\n', s1.bytes/(1024*1024));
Table(15*(k-1)+1,2)={[s1.bytes/(1024*1024)]};
%load(sprintf('C:/Users/Namalka/OneDrive - UNSW/ICS/%s/LF.mat', folder_name));

for i = 1:8
    for j = 1:8
        new_image=im2double(squeeze(LF(i,j,:,:,:)));%squeeze(LF(i,j,:,:,:));
        [height, width, n_comps] = size(new_image);
        height = height - mod(height, 8);
        width = width - mod(width, 8);
        new_image = new_image(1:height,1:width,:);
        A(i ,j ,:,:,:) = new_image;
    end
end
A=(A*255)-128; % convert the values from -128 to 127
A_orig=A;

ValArray=[200 5 10 20 30 40 50 60 70 80 90 120 150 200]%
for v=1:length(ValArray)
    %Qval=ValArray(1,v);
    Val=ValArray(1,v);
    fprintf(fileID, 'Val : %.2f \n', Val);
    Table(15*(k-1)+2,v)={[Val]};
    A=A_orig;
%% Create the DCT matrix that will be used in all further calculations
% If type is 1, the matrix is the approximate DCT matrix
% If type is 2, the matrix is the precise DCT matrix as calculated by 
% MATLAB
if (DCT_Type == 1)
   %{ Proposed 
    T1 = [1,1,1,1,1,1,1,1;
        0,1,0,0,0,0,-1,0;
        1,0,0,-1,-1,0,0,1;
        1,0,0,0,0,0,0,-1;
        1,-1,-1,1,1,-1,-1,1;
        0,0,0,1,-1,0,0,0;
        0,-1,1,0,0,1,-1,0;
        0,0,1,0,0,-1,0,0];
    
    D = diag([1/sqrt(8), 
        1/sqrt(2), 
        1/2, 
        1/sqrt(2), 
        1/sqrt(8), 
        1/sqrt(2), 
        1/2, 
        1/sqrt(2)]);
    
    T = D*T1;
end
if (DCT_Type == 2)
    T = dctmtx(8);
end
Tinv = T';

%% Perform 4D DCT by applying 2D DCTfor inter and intra 
tic;
A = intra(A, T, Tinv);%Intra compression between images
A = inter(A, T, Tinv);%inter(in, T, Tinv, threshold, Q_val)- Q_val is the quality level for Quantization matrix  
elapsedTime=toc;
fprintf(fileID, 'Elapsed Time: %.2f\n', elapsedTime);
Table(15*(k-1)+3,v)={[elapsedTime]};

%Energy before quantization
%A1=(A-min(A(:)))/(max(A(:))-min(A(:)));
%Energy_before = sum(A(:).^2)/(8*8*height*width*3);
%clear A1
%% Perform quantization on DCT applyied image
%[A,AvgZeroCoe] = inter_quantize(A, 1, Val); % Quantize within image
%[A,AvgZeroCoe] = intra_quantize(A, 1, Val);% between images- Chan
[A,AvgZeroCoe,E_ret] = LF4D_quantize(A, 1, Val); %4D 8x8x8x8 block quantization

fprintf(fileID, 'No of Avg coeficients set to zero: %.2f\n', AvgZeroCoe);
Table(15*(k-1)+4,v)={[AvgZeroCoe]};

% Energy Retined After Qunatization
%A2=(A-min(A(:)))/(max(A(:))-min(A(:)));
%Energy_after = sum(A(:).^2)/(8*8*height*width*3);
%clear A2
%Energy_ret=(Energy_after/Energy_before)*100
fprintf(fileID, 'Percentage of Retined Energy: %.2f\n', E_ret);
Table(15*(k-1)+5,v)={[E_ret]};

%%Percentage of coeficients set to zero
 B=uint8(A);
% num_zero=nnz(~B);
% zero_percent=(num_zero/(8*8*height*width*3))*100
% fprintf(fileID, 'Percentage of coeficients set to zero: %.2f\n', zero_percent);
% Table(15*(k-1)+6,v)={[zero_percent]};

%% Save the compressed file out to check compression percentage
suffix = sprintf('_encoded_%d', DCT_Type);

mkdir(sprintf('%s%s', folder_name, suffix));
save(sprintf('%s%s/compressed', folder_name, suffix), 'B');

s=dir(sprintf('%s%s/compressed.mat', folder_name, suffix));
fprintf(fileID, 'Compressed LF size: %.2f MB\n', s.bytes/(1024*1024));
Table(15*(k-1)+6,v)={[s.bytes/(1024*1024)]};

bpp=(s.bytes*8)/(8*8*height*width*3);
fprintf(fileID, 'bpp: %.2f \n', bpp);
Table(15*(k-1)+7,v)={[bpp]};
clear B
%% Swap the inverse and normal matrix to perform the decompression step
T = Tinv;
Tinv = Tinv';

A = inter(A, T, Tinv);
A = intra(A, T, Tinv);

A=uint8(A+128);

%% Save the decompressed file out as raw .m file
suffix = sprintf('_decoded_%d', DCT_Type);

% mkdir(sprintf('%s%s', folder_name, suffix));
% save(sprintf('%s%s/compressed', folder_name, suffix), 'A');

%% Save the decompressed file out as an image set
if (DCT_Type == 1) 
    name = sprintf('%s-inter-intra-ADCT', folder_name);
end
if (DCT_Type == 2)
    name = sprintf('%s-inter-intra-DCT', folder_name);
end
lightFieldToPNG(A, name);

%% Also check the image metrics for quality
[psnr,ssim]=compareQuality(fullFileName, name);
avg_psnr = sum(sum(psnr))/64;
avg_ssim = sum(sum(ssim))/64;
fprintf(fileID, 'Avg PSNR : %.2f\n', avg_psnr);
    Table(15*(k-1)+8,v)={[avg_psnr]};
fprintf(fileID, 'Min PSNR : %.2f and Max PSNR %.2f\n', min(psnr(:)),max(psnr(:)));
    Table(15*(k-1)+9,v)={[min(psnr(:)),max(psnr(:))]};
fprintf(fileID, 'Avg SSIM : %.2f\n\n\n', avg_ssim);
    Table(15*(k-1)+10,v)={[avg_ssim]};
fprintf(fileID, 'Min SSIM : %.2f and Max SSIM %.2f\n', min(ssim(:)),max(ssim(:)));
    Table(15*(k-1)+11,v)={[min(ssim(:)),max(ssim(:))]};

end
clearvars -except folder_name DCT_Type myFolder filePattern matFiles k fileID Table
end
fclose(fileID);