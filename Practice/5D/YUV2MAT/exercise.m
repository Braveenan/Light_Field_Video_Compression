clc;
clear variables;

myFolder = 'E:/Semester notes/Individual Research Project/Dataset_video/original_car/Car_15x15views_100f_512x352';
filePattern = fullfile(myFolder, '*.yuv');
yuvFiles = dir(filePattern);

base_name = 'View-0101.yuv';
videoSequence = sprintf('%s/%s', myFolder ,base_name);

width  = 512;
height = 352;
nFrame = 100;


[Y,U,V] = yuvRead(videoSequence, width, height ,nFrame); 
