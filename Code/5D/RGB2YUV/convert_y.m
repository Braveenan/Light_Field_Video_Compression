clc;
clear variables;

tic 
load('E:/Semester notes/Individual Research Project/Dataset_video/samples_2/LFVR_sample2.mat')
nlfv = 0.299.*lfv;
clear lfv

load('E:/Semester notes/Individual Research Project/Dataset_video/samples_2/LFVG_sample2.mat')
nlfv = nlfv + 0.587.*lfv;
clear lfv

load('E:/Semester notes/Individual Research Project/Dataset_video/samples_2/LFVB_sample2.mat')
nlfv = nlfv + 0.114.*lfv;
clear lfv


lfv = nlfv;
clear nlfv;
standardFileName = "LFVY_sample2.mat";
folder_name = 'Dataset_video/samples_2';
myFolder = sprintf('E:/Semester notes/Individual Research Project/%s', folder_name);
save(sprintf('%s/%s', myFolder, standardFileName), 'lfv','-v7.3')


toc