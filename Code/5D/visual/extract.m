clc;
clear variables;

myFolder = 'E:/Semester notes/Individual Research Project/Dataset_video';
baseFileName = 'LFVU_toy.mat';

lfvName = sprintf('%s/%s', myFolder ,baseFileName);
load(lfvName);

lfv_uo = lfv(:,:,:,:,1);
lfv_un = zeros([8,8,320,480]);
size(lfv_uo)
for i = 1:8
    for j = 1:8
        image = squeeze(lfv_uo(i,j,:,:));
        lfv_un(i,j,:,:) = imresize(image, 2, 'nearest');
    end
end
lfv_un = lfv_un/255;
clear lfv
clear lfv_uo
max(lfv_un(:))
min(lfv_un(:))
size(lfv_un)

baseFileName = 'LFVV_toy.mat';

lfvName = sprintf('%s/%s', myFolder ,baseFileName);
load(lfvName);

lfv_vo = lfv(:,:,:,:,1);
lfv_vn = zeros([8,8,320,480]);
size(lfv_vo)
for i = 1:8
    for j = 1:8
        image = squeeze(lfv_vo(i,j,:,:));
        lfv_vn(i,j,:,:) = imresize(image, 2, 'nearest');
    end
end
lfv_vn = lfv_vn/255;
clear lfv
clear lfv_vo
max(lfv_vn(:))
min(lfv_vn(:))
size(lfv_vn)

baseFileName = 'LFVY_toy.mat';

lfvName = sprintf('%s/%s', myFolder ,baseFileName);
load(lfvName);

lfv_yn = lfv(:,:,:,:,1);
lfv_yn = im2double(lfv_yn);
clear lfv
clear lfv_vo
max(lfv_yn(:))
min(lfv_yn(:))
size(lfv_yn)

lfv_rn = zeros([8,8,320,480]);
lfv_gn = zeros([8,8,320,480]);
lfv_bn = zeros([8,8,320,480]);

lfv_rn = 1*lfv_yn + 1.13983*lfv_vn;
lfv_gn = 1*lfv_yn - 0.39465*lfv_un - 0.58060*lfv_vn;
lfv_bn = 1*lfv_yn + 2.03211*lfv_un;

max(lfv_rn(:))
min(lfv_rn(:))
max(lfv_gn(:))
min(lfv_gn(:))
max(lfv_bn(:))
min(lfv_bn(:))

lfv = zeros([8,8,320,480,4]);
lfv(:,:,:,:,1) = lfv_yn;
lfv(:,:,:,:,2) = lfv_un;
lfv(:,:,:,:,3) = lfv_vn;

lfv = uint8(lfv*255);

max(lfv(:))
min(lfv(:))
size(lfv)

lfv_name = sprintf('%s/%s', myFolder ,"LFV_toy.mat");
save(lfv_name,'lfv','-v7.3');