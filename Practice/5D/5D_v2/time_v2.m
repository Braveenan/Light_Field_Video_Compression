function in = time_v2(in, T)
%1DCT to time axis

[n_frames, width, height, ~, ~] = size(in);
for frame = 1:8:n_frames-7
    for s=1:8
        for t=1:8
            for i = 1:height
                
                chunk_v = squeeze(in(frame:frame+7, :, i, t, s));
                
                chunk_v = (T * chunk_v) ;
                in(frame:frame+7, :, i, t, s) = chunk_v;
                
            end
        end
    end
end

end