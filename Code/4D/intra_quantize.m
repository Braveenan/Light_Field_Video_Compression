function [in,AvgZeroCoe] = intra_quantize(in, threshold, Val)
%FOUR_D Take in an array of images and perform 4D compression on it 

% Per pixel, iterate across all viewpoints. Make an intermediate 8x8 array
% to store this data and perform DCT on it. Store back after everything
% is all done.

clear D T1;
% Q = [16,11,10,16,24,40,51,61;
%     12,12,14,19,26,58,60,55;
%     14,13,16,24,40,57,69,56;
%     14,17,22,29,51,87,80,62;
%     18,22,37,56,68,109,103,77;
%     24,35,55,63,81,104,113,92;
%     49,64,78,87,103,121,120,101;
%     72,92,95,98,112,100,103,99]; % This is the JPEG Quantization matrix
% 
% if (Q_val<50)
%     Q=round((50/Q_val)*Q);
% elseif (Q_val>50)
%     Q=round(((100-Q_val)/50)*Q);
% end

Q=ones(8,8)*Val;

[~,~,height, width, n_comps] = size(in);
for comp = 1:n_comps
    for pixely = 1:height
        for pixelx = 1:width
            chunk = in(1:8,1:8,pixely,pixelx,comp);
            
            if(threshold==1)
               chunk = round(chunk ./ Q);
               chunk = chunk .* Q;
            end
            coe_after(pixely,pixelx,comp)=nnz(~chunk);

            in(1:8,1:8,pixely,pixelx, comp) = chunk;
        end
    end
end

AvgZeroCoe=(sum(coe_after(:)))/(height*width*n_comps);
fprintf(1, 'Avg no of coe. set to zero: %.2f\n', AvgZeroCoe);

end

