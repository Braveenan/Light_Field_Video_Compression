clc;
clear variables;

myFolder = 'E:/Semester notes/Individual Research Project/Dataset_video/original_david/David_15x15views_480x320/v/v_4';
filePattern = fullfile(myFolder, '*.mat');
matfiles = dir(filePattern);

lfv = zeros(8,8,160,240,40);

i = 0;

for k = 4:11
    baseFileName = matfiles(k).name;
    FourDSequence = sprintf('%s/%s', myFolder ,baseFileName);
    
    load(FourDSequence);
    
    i = i+1;
    lfv(i,:,:,:,:) = V4(4:11,:,:,1:40);   
    
end 
clear V4
lfv_name = sprintf('%s/%s', myFolder ,"LFVV_david.mat");
save(lfv_name,'lfv','-v7.3');



