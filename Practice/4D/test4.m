clc;
clear variables;

% DCT matrix that will be used in all further calculations
% The matrix is the approximate DCT matrix       
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

H(1,:,:) = D*T1;
        
% The matrix is the precise DCT matrix as calculated by MATLAB
H(2,:,:) = dctmtx(8);


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

%Table={};
for k = 1:length(matFiles)
    baseFileName = matFiles(k).name;
    fullFileName = fullfile(myFolder, baseFileName);

    fprintf(1, 'Now reading %s\n', fullFileName);
    fprintf(fileID, 'Now reading: %s\n', fullFileName);
    %Table(15*(k-1)+1,1)={baseFileName};
    load(fullFileName);

    s1=dir(sprintf('%s/%s', myFolder ,baseFileName));
    fprintf(fileID, 'Input LF size: %.2f MB\n',s1.bytes/(1024*1024));
    %Table(15*(k-1)+1,2)={[s1.bytes/(1024*1024)]};
    
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

    ValArray=[5 10 50 90 150 200];
    for v=1:length(ValArray)
        Val=ValArray(1,v);
        fprintf(fileID, 'Val : %.2f \n', Val);
        %Table(15*(k-1)+2,v)={[Val]};
        A=A_orig;
        
        for u=1:2
            tic;
            T = squeeze(H(u,:,:));
            Tinv = T';
    
% Perform 4D DCT by applying 2D DCTfor inter and intra 
            tic;
            A = intra(A, T, Tinv);%Intra compression between images
            A = inter(A, T, Tinv);%inter compression   
            elapsedTime=toc;
            fprintf(fileID, 'Elapsed Time: %.2f\n', elapsedTime);
            %Table(15*(k-1)+3,v)={[elapsedTime]};
        
% Perform quantization on DCT applyied image
            [A,AvgZeroCoe,E_ret] = LF4D_quantize(A, 1, Val); %4D 8x8x8x8 block quantization

%Percentage of coeficients set to zero
            fprintf(fileID, 'No of Avg coeficients set to zero: %.2f\n', AvgZeroCoe);
            %Table(15*(k-1)+4,v)={[AvgZeroCoe]};
        
% Energy Retined After Qunatization
            fprintf(fileID, 'Percentage of Retined Energy: %.2f\n', E_ret);
            %Table(15*(k-1)+5,v)={[E_ret]};
        
% Save the compressed file out to check compression percentage
            A_compressed=uint8(A);

            newFileName = erase(baseFileName,".mat");
            newFolder = sprintf('%s/%s', myFolder, 'compressed');
            save(sprintf('%s/%s_%d_%d_compressed', newFolder, newFileName, Val, u), 'A_compressed');

            s=dir(sprintf('%s/%s_%d_%d_compressed.mat', newFolder , newFileName, Val, u));
            fprintf(fileID, 'Compressed LF size: %.2f MB\n', s.bytes/(1024*1024));
            %Table(15*(k-1)+6,v)={[s.bytes/(1024*1024)]};

            bpp=(s.bytes*8)/(8*8*height*width*3);
            fprintf(fileID, 'bpp: %.2f \n', bpp);
            %Table(15*(k-1)+7,v)={[bpp]};
            clear A_compressed
 
% Swap the inverse and normal matrix to perform the decompression step
            T = Tinv;
            Tinv = Tinv';

            A = inter(A, T, Tinv);
            A = intra(A, T, Tinv);
            A = A+128;

            final = uint8(A+128);
            ref = uint8(A_orig);
        
        finaltime = toc
        %fprintf(fileID, '\n');
        
        end
    end 
end
fclose(fileID);