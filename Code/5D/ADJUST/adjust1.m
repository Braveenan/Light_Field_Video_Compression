clc;
clear variables;

myFolder = 'E:/Semester notes/Individual Research Project/Dataset_video/samples_new';
baseFileName = 'LFVU_new.mat';

lfvName = sprintf('%s/%s', myFolder ,baseFileName);
load(lfvName);

max(nlfv(:))
min(nlfv(:))
[vframe,iwidth,iheight,cwidth,cheight] = size(nlfv);

lfv = zeros(cheight,cwidth,iheight,iwidth,vframe-4);

for f = 1:vframe-4
    for y = 1:iwidth
        for x = 1:iheight
            for v = 1:cwidth
                for u = 1:cheight
                    lfv(u,v,x,y,f) = nlfv(f,y,x,v,u);
                    
                end
            end
        end
    end
end

clear nlfv

lfv_name = sprintf('%s/%s', myFolder ,"LFVU_samples2.mat");
save(lfv_name,'lfv','-v7.3');


