function [invert_index, idf_value, l2_norm] = build_invertIndex(vw_data,cndes,codebook_size)

invert_index = cell(codebook_size,1);
image_size   = size(cndes,2)-1;

tic;
for k1 = 1:image_size
    vw_code = vw_data(cndes(k1)+1:cndes(k1+1)); 
    for k2 = 1:size(vw_code,2);
        invert_node = [k1;k2];
        invert_index{vw_code(k2)} = [invert_index{vw_code(k2)} invert_node]; 
    end
    if(k1 / 1000 == round( k1 /1000))
        disp(k1);
    end            
end
fprintf('building invert index time is %f s \n', toc);

idf_value = zeros(codebook_size,1);
for k1 = 1:codebook_size
    vw_size = length(invert_index{k1});
    if(vw_size >0 ) 
        idf_value(k1) = log10(image_size / vw_size);
    end
end

l2_norm = zeros(image_size,1);
for k1 = 1:image_size
    bow_vec = zeros(codebook_size,1);
    vw_code = vw_data(cndes(k1)+1:cndes(k1+1)); 
    for k2 = 1:size(vw_code,2);
        bow_vec(vw_code(k2)) = bow_vec(vw_code(k2))+1;
    end
    bow_vec = bow_vec .* idf_value;
    l2_norm(k1) = norm(bow_vec,2);
    if(k1 / 1000 == round( k1 /1000))
        disp(k1);
    end            
end
