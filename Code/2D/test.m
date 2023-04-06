% ELEC 534 - Experiment 3
% Application of 2-D DCT to Image Compression
clear all; 
clc;
close all;
% Load images
load camera256.mat
load boat512.mat
load goldhill512.mat
load peppers512.mat

% Compression of camera256
[cam10,zpcam10,psnrcam10] = imcomp(camera256,10); % quality level = 10
[cam40,zpcam40,psnrcam40] = imcomp(camera256,40); % quality level = 40
[cam90,zpcam90,psnrcam90] = imcomp(camera256,90); % quality level = 90

subplot(2,2,1);
imshow(camera256,[0 255]);
title('(a) Original Image');
subplot(2,2,2);
imshow(cam10,[0 255]);
title('(b) Compressed, Quality Level = 10');
subplot(2,2,3);
imshow(cam40,[0 255]);
title('(c) Compressed, Quality Level = 40');
subplot(2,2,4);
imshow(cam90,[0 255]);
title('(d) Compressed, Quality Level = 90');
fid = fopen('Ex3.txt','wt');
fprintf(fid,'Percentage of zeros for camera256\n');
fprintf(fid,'Quality level[10 40 90] = [%.2f %.2f %.2f]\n',zpcam10,zpcam40,zpcam90);
fprintf(fid,'PSNR for camera256\n');
fprintf(fid,'Quality level[10 40 90] = [%.2f %.2f %.2f]\n',psnrcam10,psnrcam40,psnrcam90);
    
% Compression of boat512
[boat10,zpboat10,psnrboat10] = imcomp(boat512,10); % quality level = 10
[boat40,zpboat40,psnrboat40] = imcomp(boat512,40); % quality level = 40
[boat90,zpboat90,psnrboat90] = imcomp(boat512,90); % quality level = 90

figure;
subplot(2,2,1);
imshow(boat512,[0 255]);
title('(a) Original Image');
subplot(2,2,2);
imshow(boat10,[0 255]);
title('(b) Compressed, Quality Level = 10');
subplot(2,2,3);
imshow(boat40,[0 255]);
title('(c) Compressed, Quality Level = 40');
subplot(2,2,4);
imshow(boat90,[0 255]);
title('(d) Compressed, Quality Level = 90');
fprintf(fid,'\nPercentage of zeros for boat512\n');
fprintf(fid,'Quality level[10 40 90] = [%.2f %.2f %.2f]\n',zpboat10,zpboat40,zpboat90);
fprintf(fid,'PSNR for boat512\n');
fprintf(fid,'Quality level[10 40 90] = [%.2f %.2f %.2f]\n',psnrboat10,psnrboat40,psnrboat90);
    
% Compression of goldhill512
[gh10,zpgh10,psnrgh10] = imcomp(goldhill512,10); % quality level = 10
[gh40,zpgh40,psnrgh40] = imcomp(goldhill512,40); % quality level = 40
[gh90,zpgh90,psnrgh90] = imcomp(goldhill512,90); % quality level = 90

figure;
subplot(2,2,1);
imshow(goldhill512,[0 255]);
title('(a) Original Image');
subplot(2,2,2);
imshow(gh10,[0 255]);
title('(b) Compressed, Quality Level = 10');
subplot(2,2,3);
imshow(gh40,[0 255]);
title('(c) Compressed, Quality Level = 40');
subplot(2,2,4);
imshow(gh90,[0 255]);
title('(d) Compressed, Quality Level = 90');
fprintf(fid,'\nPercentage of zeros for goldhill512\n');
fprintf(fid,'Quality level[10 40 90] = [%.2f %.2f %.2f]\n',zpgh10,zpgh40,zpgh90);
fprintf(fid,'PSNR for goldhill512\n');
fprintf(fid,'Quality level[10 40 90] = [%.2f %.2f %.2f]\n',psnrgh10,psnrgh40,psnrgh90);

% Compression of peppers512
[pepp10,zppepp10,psnrpepp10] = imcomp(peppers512,10); % quality level = 10
[pepp40,zppepp40,psnrpepp40] = imcomp(peppers512,40); % quality level = 40
[pepp90,zppepp90,psnrpepp90] = imcomp(peppers512,90); % quality level = 90

figure;
subplot(2,2,1);
imshow(peppers512,[0 255]);
title('(a) Original Image');
subplot(2,2,2);
imshow(pepp10,[0 255]);
title('(b) Compressed, Quality Level = 10');
subplot(2,2,3);
imshow(pepp40,[0 255]);
title('(c) Compressed, Quality Level = 40');
subplot(2,2,4);
imshow(pepp90,[0 255]);
title('(d) Compressed, Quality Level = 90');
fprintf(fid,'\nPercentage of zeros for peppers512\n');
fprintf(fid,'Quality level[10 40 90] = [%.2f %.2f %.2f]\n',zppepp10,zppepp40,zppepp90);
fprintf(fid,'PSNR for peppers512\n');
fprintf(fid,'Quality level[10 40 90] = [%.2f %.2f %.2f]\n',psnrpepp10,psnrpepp40,psnrpepp90);
fclose(fid);