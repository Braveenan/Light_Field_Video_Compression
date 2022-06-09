function [in] = epi_compress(in, T, Tinv, threshold)
% Compress an image taking one dimension as viewpoint and one as pix. index

Q = [16,11,10,16,24,40,51,61;
    12,12,14,19,26,58,60,55;
    14,13,16,24,40,57,69,56;
    14,17,22,29,51,87,80,62;
    18,22,37,56,68,109,103,77;
    24,35,55,63,81,104,113,92;
    49,64,78,87,103,121,120,101;
    72,92,95,98,112,100,103,99];

%Improce quality level to 80
%Q=round(((100-80)/50)*Q);

[~,~,height, width, n_comps] = size(in);
buf = zeros(8,8);

for u = 1:height
    for s = 1:8
       for i = 1:8:width-7
           for layer = 1:n_comps
               buf = squeeze(in(s, 1:8, u, i:i+7, layer)); 
               buf = T * buf * Tinv;
               
               if (threshold == 1)      
                   buf = round(buf ./ Q);
                   buf = buf .* Q;
               end
               
               in(s, 1:8, u, i:i+7, layer) = buf;
           end
       end    
    end
end

for v = 1:width
    for t = 1:8
       for i = 1:8:height-7
          for layer = 1:n_comps
               buf = squeeze(in(1:8, t, i:i+7, v, layer)); 
               buf = T * buf * Tinv;
               
               if (threshold == 1)      
                   buf = round(buf ./ Q);
                   buf = buf .* Q;
               end
               
               in(1:8, t, i:i+7, v, layer) = buf;
           end
       end    
    end
end

end

