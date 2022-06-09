clc;
clear variables;

myFolder = 'E:/Semester notes/Individual Research Project/Dataset_video';
filePattern = fullfile(myFolder, '*.mat');
matFiles = dir(filePattern);

fileID = fopen(sprintf('%s/%s.txt', myFolder , 'shape'), 'wt');

for k = 1:length(matFiles)
    baseFileName = matFiles(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    newFileName = erase(baseFileName,".mat");
    
    load(fullFileName);
    [x, y, u, v, n_frames] = size(lfv);
    
    fprintf(fileID, '%s\n',newFileName);
    
    fprintf(fileID, 'camera_x = %d\n',x);
    fprintf(fileID, 'camera_y = %d\n',y);
    fprintf(fileID, 'image_u = %d\n',u);
    fprintf(fileID, 'image_v = %d\n',v);
    fprintf(fileID, 'n_frames = %d\n',n_frames);
    
    s=dir(sprintf('%s/%s.mat', myFolder , newFileName));
    fprintf(fileID, 'LFV size: %.2f MB\n\n', s.bytes/(1024*1024));
    
end 