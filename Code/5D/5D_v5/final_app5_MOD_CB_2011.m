clc;
clear variables;

%Reading input dataset from folder
folder_name = 'Dataset_video';
myFolder = sprintf('E:/Semester notes/Individual Research Project/%s', folder_name);

if ~isdir(myFolder)
errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
uiwait(warndlg(errorMessage));
return;
end
filePattern = fullfile(myFolder, '*.mat');
matFiles = dir(filePattern);

%constant value of quantization matrix
Val = 200;  

%approximate dct matrix
T1 = [1,1,1,1,1,1,1,1;
      1,0,0,0,0,0,0,-1;
      1,0,0,-1,-1,0,0,1;
      0,0,-1,0,0,1,0,0;
      1,-1,-1,1,1,-1,-1,1;
      0,-1,0,0,0,0,1,0;
      0,-1,1,0,0,1,-1,0;
      0,0,0,-1,1,0,0,0];
    
D = diag([1/sqrt(8), 
    1/sqrt(2), 
    1/2, 
    1/sqrt(2), 
    1/sqrt(8), 
    1/sqrt(2), 
    1/2, 
    1/sqrt(2)]);
    
T = D*T1;
clear D
clear T1

for k = 1:length(matFiles)
    baseFileName = matFiles(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    newFileName = erase(baseFileName,".mat");

    %creating text file
    fileID = fopen(sprintf('%s/%s_%d_app4_MOD_CB_2011.txt', myFolder , newFileName, Val), 'wt');

    %loading lightfield video
    fprintf(1, 'Now reading %s\n', fullFileName);
    fprintf(fileID, 'Now reading: %s\n', fullFileName);
    load(fullFileName);

    %calculating size
    s1=dir(sprintf('%s/%s', myFolder ,baseFileName));
    fprintf(1, 'Input LF size: %.2f MB\n',s1.bytes/(1024*1024));
    fprintf(fileID, 'Input LF size: %.2f MB\n',s1.bytes/(1024*1024));
    
    %reducing size
    new_video=im2double(lfv(1:8,1:8,:,:,:));
    clear lfv
    [~,~,height, width, n_frames] = size(new_video);
    height = height - mod(height, 8);
    width = width - mod(width, 8);
    n_frames = n_frames - mod(n_frames, 8);
    A = new_video(1:8,1:8,1:height,1:width,1:n_frames);
    clear new_video
           
    % convert the values from -128 to 127
    A=(A*255)-128; 
    A_orig=A+128;
           
    % Perform 5D DCT
    fprintf(1, 'Approximate DCT for %s\n',baseFileName);
    fprintf(fileID, 'Approximate DCT for %s\n',baseFileName);
    tic;
    for (frame = 1:n_frames)
        A_s = squeeze(A(:,:,:,:,frame));
        A_s = intra(A_s, T, T');%Intra compression between images
        A_s = inter(A_s, T, T');%Intra compression between images
        A(:,:,:,:,frame) = A_s;   
    end
    clear A_s
    fprintf(1, '4D compression done for %s\n',baseFileName);
    
    A = time(A, T);%Time compression
    fprintf(1, '5D compression done for %s\n',baseFileName);
    
    compressionTime=toc;
    fprintf(fileID, 'Compression Time: %.2f\n', compressionTime);
    fprintf(1, 'Compression Time: %.2f\n', compressionTime);
    
    % Perform quantization on DCT applyied image
    [A,AvgZeroCoe,E_ret] = LF5D_quantize(A, Val); %5D 8x8x8x8x8 block quantization
    
    %Percentage of coeficients set to zero
    fprintf(fileID, 'No of Avg coeficients set to zero: %.2f\n', AvgZeroCoe);
    fprintf(1, 'No of Avg coeficients set to zero: %.2f\n', AvgZeroCoe);
        
    % Energy Retined After Qunatization
    fprintf(fileID, 'Percentage of Retined Energy: %.2f\n', E_ret);
    fprintf(1, 'Percentage of Retined Energy: %.2f\n', E_ret);
    
    % Save the compressed file out to check compression percentage
    A_compressed=uint8(A);
    
    newFileName = erase(baseFileName,".mat");
    newFolder = sprintf('%s/%s', myFolder, 'compressed_video');
    save(sprintf('%s/%s_%d_compressed', newFolder, newFileName, Val), 'A_compressed');

    s=dir(sprintf('%s/%s_%d_compressed.mat', newFolder , newFileName, Val));
    fprintf(fileID, 'Compressed LF size: %.2f MB\n', s.bytes/(1024*1024));

    % Calculate bpp
    bpp=(s.bytes*8)/(8*8*height*width*n_frames);
    fprintf(1, 'bpp: %.2f \n', bpp);
    fprintf(fileID, 'bpp: %.2f \n', bpp);
    clear A_compressed
    
    % Swap the inverse and normal matrix to perform the decompression step
    tic;
    A = time(A, T');%Time compression
    fprintf(1, '1D reconstruction done for %s\n',baseFileName);
    
    for (frame = 1:n_frames)
        A_s = squeeze(A(:,:,:,:,frame));
        A_s = inter(A_s, T', T);
        A_s = intra(A_s, T', T);
        A(:,:,:,:,frame) = A_s;   
    end
    clear A_s
    A = A+128;
    fprintf(1, '5D reconstruction done for %s\n',baseFileName);
       
    reconstructionTime=toc;
    fprintf(fileID, 'Reconstruction Time: %.2f\n', reconstructionTime);
    fprintf(1, 'Reconstruction Time: %.2f\n', reconstructionTime);
    
    % Calculate PSNR
    A = uint8(A);
    A_orig = uint8(A_orig);
    
    tic;
    no_of_pixels = 8*8*height*width*n_frames;
    PSNR = compare(A, A_orig, n_frames, no_of_pixels);
    fprintf(1, 'PSNR done for %s\n',baseFileName);
    
    psnrTime=toc;
    fprintf(fileID, 'PSNR value: %.2f\n', PSNR);
    fprintf(1, 'PSNR value: %.2f\n', PSNR);
    fprintf(fileID, 'PSNR Time: %.2f\n', psnrTime);
    fprintf(1, 'PSNR Time: %.2f\n', psnrTime);
 
end

clear T