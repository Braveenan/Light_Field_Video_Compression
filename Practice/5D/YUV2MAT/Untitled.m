clc
clear variables

myFile = 'E:/Semester notes/Individual Research Project/Dataset_video/original_car/LFVY_car.mat';
newFile = 'E:/Semester notes/Individual Research Project/Dataset_video/original_car/LFVY1_car.mat';
load(myFile)

size(lfv)

lfv = lfv(:,:,:,:,1:24);
save(newFile,'lfv','-v7.3')
