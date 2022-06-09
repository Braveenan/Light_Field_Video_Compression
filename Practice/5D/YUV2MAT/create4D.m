clc;
clear variables;

myFolder = 'E:/Semester notes/Individual Research Project/Dataset_video/original_david/David_15x15views_480x320/u';
filePattern = fullfile(myFolder, '*.mat');
matfiles = dir(filePattern);

U4 = zeros(15,160,240,100);

i = 0;

for k = 210:225
    baseFileName = matfiles(k).name;
    videoSequence = sprintf('%s/%s', myFolder ,baseFileName);
    
    load(videoSequence);
    
    i = i+1;
    U4(i,:,:,:) = U;   
    
end 

newFileName = erase(baseFileName,"15_u.mat");
u4_name = sprintf('%s/%s/%s', myFolder ,"u_4" ,newFileName+"_u.mat");
save(u4_name,'U4','-v7.3');
