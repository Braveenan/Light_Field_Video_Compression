function [R,zeroper,psnr] = imcomp(image,qualev)

% IMCOMP compresses the images using 2-D DCT
% inputs
% image - image to be compressed
% qualev - quality level
% outputs
% R - reconstructed image
% zeroper - percentage of zero coefficients
% psnr - peak signal-to-noise ratio
% Divide image into 8x8 blocks

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

if (qualev > 50 && qualev <= 100)
    tau = (100-qualev)/50;
    Q = round(tau*Q50);
    for i = 1:8
        for j = 1:8
            if (Q(i,j)>255)
            Q(i,j) = 255; % clip the values grater than 255
            end
        end
    end
elseif (qualev < 50 && qualev >= 0)
    tau = 50/qualev;
    Q = round(tau*Q50);
elseif (qualev == 50)
    Q = Q50;
else
    fprintf('\nError: quality level should be between 0 and 100.\n');
end

totzero = 0; % initialization of total number of zeros

% Image compression and reconstruction
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
        for p = 1:8 % count number of zero coefficients
            for q = 1:8
                if (D(p,q) == 0)
                    totzero = totzero + 1; % increase by one
                end
            end
        end
        ini2 = ini2 + 8; % update ini2
    end
    ini1 = ini1 + 8; % update ini1
end

zeroper = totzero*100/(M*N); % percentage of zero coefficients

% calculate PSNR
psimax = 255; % maximum light intensity
sigmasq = mean(mean((R-image).^2)); % mean square error
psnr = 10*log10(psimax^2/sigmasq);