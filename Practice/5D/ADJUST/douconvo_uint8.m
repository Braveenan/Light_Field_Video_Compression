clc;
clear variables;

myFolder = 'E:/Semester notes/Individual Research Project/Dataset_video/samples_2';

baseFileName = 'LFVR_new2.mat';
lfvName = sprintf('%s/%s', myFolder ,baseFileName);
load(lfvName);

lfv = lfv*255;
lfv = uint8(lfv);
lfv_name = sprintf('%s/%s', myFolder ,"LFVR_sample2.mat");
save(lfv_name,'lfv','-v7.3');
clear lfv

baseFileName = 'LFVG_new2.mat';
lfvName = sprintf('%s/%s', myFolder ,baseFileName);
load(lfvName);

lfv = lfv*255;
lfv = uint8(lfv);
lfv_name = sprintf('%s/%s', myFolder ,"LFVG_sample2.mat");
save(lfv_name,'lfv','-v7.3');
clear lfv

baseFileName = 'LFVB_new2.mat';
lfvName = sprintf('%s/%s', myFolder ,baseFileName);
load(lfvName);

lfv = lfv*255;
lfv = uint8(lfv);
lfv_name = sprintf('%s/%s', myFolder ,"LFVB_sample2.mat");
save(lfv_name,'lfv','-v7.3');
clear lfv
