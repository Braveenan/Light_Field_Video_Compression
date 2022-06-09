function [in,AvgZeroCoe,E_ret] = LF5D_quantize(in, Qval)
%FOUR_D Take in an array of images and perform 4D compression on it 

% Per pixel, iterate across all viewpoints. Make an intermediate 8x8 array
% to store this data and perform DCT on it. Store back after everything
% is all done.

clear D T1;
Q=ones(8,8,8,8,8);
Q=Q*Qval;

[~,~,height, width, n_frames] = size(in);
for f = 1:8:n_frames - 7
    for i = 1:8:height - 7
        for j = 1:8:width - 7
        chunk = squeeze(in(1:8, 1:8, i:i + 7, j:j + 7, f:f + 7));
        %coe_before((i+7)/8,(j+7)/8,(f+7)/8)=nnz(~chunk);
        Energy_before((i+7)/8,(j+7)/8,(f+7)/8)=sum(chunk(:).^2)/(8*8*8*8*8);

        chunk = round(chunk ./ Q);
        chunk = chunk .* Q;

        coe_after((i+7)/8,(j+7)/8,(f+7)/8)=nnz(~chunk);
        Energy_after((i+7)/8,(j+7)/8,(f+7)/8)=sum(chunk(:).^2)/(8*8*8*8*8);

        in(1:8, 1:8, i:i + 7, j:j + 7, f:f + 7) = chunk;
        end
    end
end

AvgZeroCoe=sum(sum(sum(coe_after)))/((height/8)*(width/8)*(n_frames/8));
%fprintf(1, 'Avg no of coe. set to zero: %.2f\n', AvgZeroCoe);

AvgEnergyBefore=sum(sum(sum(Energy_before)))/((height/8)*(width/8)*(n_frames/8));
%fprintf(1, 'Energy Before: %.2f\n', AvgEnergyBefore);

AvgEnergyAfter=sum(sum(sum(Energy_after)))/((height/8)*(width/8)*(n_frames/8));
%fprintf(1, 'Energy After: %.2f\n', AvgEnergyAfter);

E=Energy_after./Energy_before;
E_ret=sum(sum(sum(E)))/((height/8)*(width/8)*(n_frames/8));
%fprintf(1, 'Energy Retaned: %.2f\n',E_ret);
end

