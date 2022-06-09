clc;
clear variables;

tic 
load('E:/Semester notes/Individual Research Project/Dataset_video/samples_2/LFVR_sample2.mat')
lfv = im2double(lfv);
nlfv = 0.615.*lfv;
clear lfv

load('E:/Semester notes/Individual Research Project/Dataset_video/samples_2/LFVG_sample2.mat')
lfv = im2double(lfv);
nlfv = nlfv - 0.515.*lfv;
clear lfv

load('E:/Semester notes/Individual Research Project/Dataset_video/samples_2/LFVB_sample2.mat')
lfv = im2double(lfv);
nlfv = nlfv - 0.1.*lfv;
clear lfv

nlfv = nlfv*255;
lfv = uint8(nlfv);
clear nlfv;
standardFileName = "LFVV_new2.mat";
folder_name = 'Dataset_video';
myFolder = sprintf('E:/Semester notes/Individual Research Project/%s', folder_name);
save(sprintf('%s/%s', myFolder, standardFileName), 'lfv','-v7.3')

toc