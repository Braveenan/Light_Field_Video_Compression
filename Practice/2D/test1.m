clc;
clear all;
% Load images
load camera256.mat
load boat512.mat
load goldhill512.mat
load peppers512.mat

image = peppers512;
[M,N] = size(image);
m = M/8; % number of blocks along dimension 1
n = N/8; % number of blocks along dimension 2

% Determine the quantization matrix
Q50 = [16,11,10,16,24,40,51,61; 
12,12,14,19,26,58,60,55;
14,13,16,24,40,57,69,56;
14,17,22,29,51,87,80,62;
18,22,37,56,68,109,103,77;
24,35,55,64,81,104,113,92;
49,64,78,87,103,121,120,101;
72,92,95,98,112,100,103,99]; % matrix for quality level =50

Q = Q50;

totzero = 0; % initialization of total number of zeros

% Image compression and reconstruction
tic
ini1 = 1; % initial position of the block (dim 1)
for i = 1:m
    ini2 = 1; % initial position of the block (dim 2)
    for j = 1:n
        B = image(ini1:ini1+7,ini2:ini2+7); % extract the 8x8 block
        Blo = B - 128; % level off by subtracting 128
        C = dct2(Blo); % apply 2-D DCT
        S = round(C./Q); % quantization
        D = Q.*S; % decompression
        E = idct2(D); % apply 2-D IDCT
        R(ini1:ini1+7,ini2:ini2+7) = E + 128; % compensation for level-off
        ini2 = ini2 + 8; % update ini2
    end
    ini1 = ini1 + 8; % update ini1
end
toc