function tf_data = build_tf(vw_data,cndes,codebook_size)

image_size  = size(cndes,2) -1;
tf_data = zeros(codebook_size,image_size);
for k1 = 1:image_size
    
    vw_code = vw_data(cndes(k1)+1:cndes(k1+1));         
    for k2 = 1:size(vw_code,2)
       tf_data(vw_code(k2),k1) = tf_data(vw_code(k2),k1) +1; 
    end    
end