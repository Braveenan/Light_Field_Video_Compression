clc;
clear all;
% Load images
load camera256.mat
load boat512.mat
load goldhill512.mat
load peppers512.mat

image = camera256;
[M,N] = size(image);
m = M/4; % number of blocks along dimension 1
n = N/4; % number of blocks along dimension 2

% Determine the quantization matrix
Q50 = [16,11,10,16; 
12,12,14,19;
14,13,16,24;
14,17,22,29]; % matrix for quality level =50

Q = Q50;

totzero = 0; % initialization of total number of zeros

% Image compression and reconstruction
ini1 = 1; % initial position of the block (dim 1)
for i = 1:m
    ini2 = 1; % initial position of the block (dim 2)
    for j = 1:n
        B = image(ini1:ini1+3,ini2:ini2+3); % extract the 8x8 block
        Blo = B - 128; % level off by subtracting 128
        C = dct2(Blo); % apply 2-D DCT
        S = round(C./Q); % quantization
        D = Q.*S; % decompression
        E = idct2(D); % apply 2-D IDCT
        R(ini1:ini1+3,ini2:ini2+3) = E + 128; % compensation for level-off
        ini2 = ini2 + 4; % update ini2
    end
    ini1 = ini1 + 4; % update ini1
end

B
Blo
C
S
D
E