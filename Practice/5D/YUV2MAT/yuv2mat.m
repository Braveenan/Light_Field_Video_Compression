clc;
clear variables;

myFolder = 'E:/Semester notes/Individual Research Project/Dataset_video/original_david/David_15x15views_480x320';
filePattern = fullfile(myFolder, '*.yuv');
yuvFiles = dir(filePattern);

for k = 1:length(yuvFiles)
    
baseFileName = yuvFiles(k).name;
videoSequence = sprintf('%s/%s', myFolder ,baseFileName);

width  = 480;
height = 320;
nFrame = 100;

[Y,U,V] = yuvRead(videoSequence, width, height ,nFrame); 
clear Y
%clear V
clear U

newFileName = erase(baseFileName,".yuv");

%y_name = sprintf('%s/%s/%s', myFolder ,"y" ,newFileName+"_y.mat");
%save(y_name,'Y');

%u_name = sprintf('%s/%s/%s', myFolder ,"u" ,newFileName+"_u.mat");
%save(u_name,'U');

v_name = sprintf('%s/%s/%s', myFolder ,"v" ,newFileName+"_v.mat");
save(v_name,'V');

fclose all;

end 