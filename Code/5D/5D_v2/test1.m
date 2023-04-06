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
Val = 150;  

%dct matrix
T = dctmtx(8);

for k = 1:length(matFiles)
    tic
    baseFileName = matFiles(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    newFileName = erase(baseFileName,".mat");

    %creating text file
    fileID = fopen(sprintf('%s/%s_%d_metadata.txt', myFolder , newFileName, Val), 'wt');

    %loading lightfield video
    fprintf(1, 'Now reading %s\n', fullFileName);
    fprintf(fileID, 'Now reading: %s\n', fullFileName);
    load(fullFileName);

    %calculating size
    s1=dir(sprintf('%s/%s', myFolder ,baseFileName));
    fprintf(1, 'Input LF size: %.2f MB\n',s1.bytes/(1024*1024));
    fprintf(fileID, 'Input LF size: %.2f MB\n',s1.bytes/(1024*1024));
    
    %reducing size
    new_video=im2double(lfv(:,:,:,1:8,1:8));
    clear lfv
    [n_frames, width, height, ~, ~] = size(new_video);
    height = height - mod(height, 8);
    width = width - mod(width, 8);
    n_frames = n_frames - mod(n_frames, 8);
    A = new_video(1:n_frames,1:width,1:height,1:8,1:8);
    clear new_video
       
    % convert the values from -128 to 127
    A=(A*255)-128; 
    A_orig=A;
       
    % Perform 5D DCT 
    tic;
    for (frame = 1:n_frames)
        A_s = squeeze(A(frame,:,:,:,:));
        A_s = intra(A_s, T, T');%Intra compression between images
        A_s = inter(A_s, T, T');%Intra compression between images
        A(frame,:,:,:,:) = A_s;   
    end
    clear A_s
    fprintf(1, '4D compression done for %s\n',baseFileName);
    
    A = time_v2(A, T);%Time compression
    fprintf(1, '5D compression done for %s\n',baseFileName);
    
    compressionTime=toc;
    fprintf(fileID, 'Compression Time: %.2f\n', compressionTime);
    fprintf(1, 'Compression Time: %.2f\n', compressionTime);
     
    elapsedTime=toc;
    fprintf(fileID, 'Elapsed Time: %.2f\n', elapsedTime);
    fprintf(1, 'Elapsed Time: %.2f\n', elapsedTime);
 
end