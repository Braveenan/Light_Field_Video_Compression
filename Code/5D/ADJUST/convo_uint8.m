clc;
clear variables;

myFolder = 'E:/Semester notes/Individual Research Project/Dataset_video/original_david';
baseFileName = 'LFVY_david.mat';

lfvName = sprintf('%s/%s', myFolder ,baseFileName);
load(lfvName);

max(lfv(:))
min(lfv(:))

lfv = uint8(lfv);

max(lfv(:))
min(lfv(:))
size(lfv)
lfv_name = sprintf('%s/%s', myFolder ,"LFVY_david1.mat");
save(lfv_name,'lfv','-v7.3');

