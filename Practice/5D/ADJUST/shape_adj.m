clc;
clear variables;

myFolder = 'E:/Semester notes/Individual Research Project/Dataset_video/original_david';
baseFileName = 'LFVV_david.mat';

lfvName = sprintf('%s/%s', myFolder ,baseFileName);
load(lfvName);

size(lfv)

lfv = lfv(:,:,:,:,1:24);
lfv_name = sprintf('%s/%s', myFolder ,"LFVV_david1.mat");
save(lfv_name,'lfv','-v7.3');

size(lfv)