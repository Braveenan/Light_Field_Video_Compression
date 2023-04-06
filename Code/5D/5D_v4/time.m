function in = time(in, T)
%1DCT to time axis

[~,~,height, width, n_frames] = size(in);
for frame = 1:8:n_frames-7
    for s=1:8
        for t=1:8
            for i = 1:height
                
                chunk_v = squeeze(in(s, t, i, :, frame:frame+7));
                
                chunk_v = (T * chunk_v') ;
                in(s, t, i, :, frame:frame+7) = chunk_v';
                
            end
        end
    end
end

end