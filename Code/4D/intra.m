function [in] = intra(in, T, Tinv)
%2D DCT to intra sub-aperture image 

% Per pixel, iterate across all viewpoints. Make an intermediate 8x8 array
% to store this data and perform DCT on it. Store back after everything
% is all done.


[~,~,height, width, n_comps] = size(in);
for comp = 1:n_comps
    for pixely = 1:height
        for pixelx = 1:width
            chunk = in(1:8,1:8,pixely,pixelx,comp);
            chunk = (T* chunk * Tinv) ; 
            
            in(1:8,1:8,pixely,pixelx, comp) = chunk;
        end
    end
end

end

