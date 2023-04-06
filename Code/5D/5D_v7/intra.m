 function [in] = intra(in, T, Tinv)
%2D DCT to each sub-aperture image seperately

% Per pixel, iterate across all viewpoints. Make an intermediate 8x8 array
% to store this data and perform DCT on it. Store back after everything
% is all done.


[~,~,height, width] = size(in);
for s=1:8
    for t=1:8
        for i = 1:8:height - 7
            for j = 1:8:width - 7
                chunk = squeeze(in(s, t, i:i + 7, j:j + 7));
                chunk = (T * chunk * Tinv) ;
                in(s, t, i:i + 7, j:j + 7) = chunk;
            end
        end
    end
end

end

