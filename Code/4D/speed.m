clc;
A = randn(8,8,8,8);
B = randn(8,8,8,8);

tic;
psnr(A,B)
time1 = toc

help parpool
tic;
psnr(A,B)
time1 = toc

