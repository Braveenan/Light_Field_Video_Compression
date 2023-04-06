clc
clear all

myFolder = 'E:/Semester notes/Individual Research Project/Dataset_video';
filePattern = fullfile(myFolder, '*.mat');
matFiles = dir(filePattern);

fileID = fopen(sprintf('%s/specification.txt', myFolder), 'wt');

for k = 1:length(matFiles)
    baseFileName = matFiles(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    newFileName = erase(baseFileName,".mat");
    
    fprintf(fileID, 'Name: %s\n', newFileName);
    load(fullFileName);
    
    [x,y,u,v,f] = size(lfv);
    fprintf(fileID, 'Size: %d,%d,%d,%d,%d\n', x,y,u,v,f);
    
    fprintf(fileID, 'Maximum: %d\n', max(lfv(:)));
    fprintf(fileID, 'Minimum: %d\n', min(lfv(:)));
    fprintf(fileID, 'Retained coefficients: %d\n', nnz(lfv));
    
end