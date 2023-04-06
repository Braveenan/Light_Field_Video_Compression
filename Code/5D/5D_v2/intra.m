function [in] = intra(in, T, Tinv)
%2D DCT to intra sub-aperture image 

% Per pixel, iterate across all viewpoints. Make an intermediate 8x8 array
% to store this data and perform DCT on it. Store back after everything
% is all done.


[width, height, ~, ~] = size(in);
for pixely = 1:height
    for pixelx = 1:width
        chunk = squeeze(in(pixelx,pixely,1:8,1:8));
        chunk = (T* chunk' * Tinv) ; 

        in(pixelx,pixely,1:8,1:8) = chunk';
    end
end

end

