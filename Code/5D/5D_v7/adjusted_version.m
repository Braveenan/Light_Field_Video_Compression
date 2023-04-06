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

%constant value matrix
%ValArray = [1 3 5 7 10 15 25 35 50 80 100 120 150 180 200];
ValArray = [180 200];

%proposed approximate dct matrix
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
clear D
clear T1

for k = 1:length(matFiles)
    baseFileName = matFiles(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    newFileName = erase(baseFileName,".mat");

    %loading lightfield video
    load(fullFileName);

    %calculating size
    s1=dir(sprintf('%s/%s', myFolder ,baseFileName));
        
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
    A_orig=A;
        
    for v=1:20
        %creating text file
        Val=120;
        fileID = fopen(sprintf('%s/%s_%d_app6_PMC_2014.txt', myFolder , newFileName, v), 'wt');

        % Perform 5D DCT
        fprintf(1, 'PMC 2014 DCT for %s\n',baseFileName);
        fprintf(fileID, 'PMC 2014 DCT for %s\n',baseFileName);
        tic;
        for (frame = 1:n_frames)
            A_s = squeeze(A(:,:,:,:,frame));
            A_s = intra(A_s, T, T');%Intra compression 
            A_s = inter(A_s, T, T');%Inter compression
            A(:,:,:,:,frame) = A_s;   
        end
        clear A_s
        fprintf(1, '4D compression done for %s\n',baseFileName);

        A = time(A, T);%Time compression
        fprintf(1, '5D compression done for %s\n',baseFileName);

        % Perform quantization on DCT applyied image
        [A,AvgZeroCoe,E_ret] = LF5D_quantize(A, Val); %5D 8x8x8x8x8 block quantization
        
        compressionTime=toc;
        fprintf(fileID, 'Compression Time: %.2f\n', compressionTime);
        fprintf(1, 'Compression Time: %.2f\n', compressionTime);

        
        
        A_orig = im2double(A_orig);
        A_orig = (A_orig*255)-128; 
        A = A_orig;
                
    end 
 
end

clear T