function [in,AvgZeroCoe] = inter_quantize(in, threshold, Q_val)
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
%     72,92,95,98,112,100,103,99]; % This is the Quantization matrix
% 
% if (Q_val<50)
%     Q=round((50/Q_val)*Q);
% elseif (Q_val>50)
%     Q=round(((100-Q_val)/50)*Q);
% end

Q=ones(8,8)*Q_val;

[~,~,height, width, n_comps] = size(in);
for clr = 1:n_comps
    for s=1:8
        for t=1:8
            for i = 1:8:height - 7
                for j = 1:8:width - 7
                    chunk = squeeze(in(s, t, i:i + 7, j:j + 7, clr));
                  
                    if(threshold==1)
                    chunk = round(chunk ./ Q);
                    chunk = chunk .* Q;
                    end
                    coe_after(s,t,(i+7)/8,(j+7)/8,clr)=nnz(~chunk);
                    
                    in(s, t, i:i + 7, j:j + 7, clr) = chunk;
                end
            end
        end
    end
end

AvgZeroCoe=(sum(coe_after(:)))/(8*8*( height/8)*(width/8)*n_comps);
fprintf(1, 'Avg no of coe. set to zero: %.2f\n', AvgZeroCoe);

end

