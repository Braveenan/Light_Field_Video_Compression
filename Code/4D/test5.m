clc;
clear variables;

%Reading input dataset 
folder_name = 'Dataset';
myFolder = sprintf('E:/Semester notes/Individual Research Project/%s', folder_name);

if ~isdir(myFolder)
errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
uiwait(warndlg(errorMessage));
return;
end

filePattern = fullfile(myFolder, '*.mat');
matFiles = dir(filePattern);
fileID = fopen(sprintf('E:/Semester notes/Individual Research Project/Practice/4D/metadata.txt'), 'wt');%OpenFile to write all data

baseFileName = 'Friends.mat';
fullFileName = fullfile(myFolder, baseFileName);

fprintf(1, 'Now reading %s\n', fullFileName);
fprintf(fileID, 'Now reading: %s\n', fullFileName);

load(fullFileName);

s1=dir(sprintf('%s/%s', myFolder ,baseFileName));
fprintf(fileID, 'Input LF size: %.2f MB\n',s1.bytes/(1024*1024));

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

pix1 = A(2,8,9,7,1)
pix1_1 = A(1,1,9,6,3)

A=(A*255)-128; % convert the values from -128 to 127
m = max(A(:));
A_orig=A;

pix2 = A(2,8,9,7,1)
pix2_1 = A(1,1,9,6,3)

Val = 1;

T = dctmtx(8);
Tinv = T';

tic;
A = intra(A, T, Tinv);%Intra compression between images
intraTime=toc;
fprintf(fileID, 'Intra Time: %.2f\n', intraTime);

pix3 = A(2,8,9,7,1)
pix3_1 = A(1,1,9,6,3)

tic;
A = inter(A, T, Tinv);%inter compression
interTime=toc;
fprintf(fileID, 'Inter Time: %.2f\n', interTime);

pix4 = A(2,8,9,7,1)
pix4_1 = A(1,1,9,6,3)

[A,AvgZeroCoe,E_ret] = LF4D_quantize(A, 1, Val); %4D 8x8x8x8 block quantization
pix5 = A(2,8,9,7,1)
pix5_1 = A(1,1,9,6,3)

T = Tinv;
Tinv = Tinv';

A = inter(A, T, Tinv);
pix6 = A(2,8,9,7,1)
pix6_1 = A(1,1,9,6,3)

A = intra(A, T, Tinv);
pix7 = A(2,8,9,7,1)
pix7_1 = A(1,1,9,6,3)

A = A+128;
pix8 = A(2,8,9,7,1)
pix8_1 = A(1,1,9,6,3)
m1 = max(A(:));
%A = uint8(A);
%m2 = max(A(:));

