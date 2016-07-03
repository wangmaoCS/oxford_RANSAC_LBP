function [result_list, result_score] = query_image(vw_data, cndes,qidx, invert_index,idf_value,l2_norm)

query_size = size(qidx,1);
image_size = size(l2_norm,1);
result_list  =  zeros(image_size,query_size);
result_score =  zeros(image_size,query_size);

for k1 = 1:query_size    
    q_vw_code = vw_data(cndes(qidx(k1))+1:cndes(qidx(k1) + 1));
    
    for k2 = 1:size(q_vw_code,2)
        invert_list = invert_index{q_vw_code(k2)};
        idf_weight = idf_value(q_vw_code(k2));
        
        for k3 = 1:size(invert_list,2)
            image_id = invert_list(1,k3);            
            result_score(image_id,k1) = result_score(image_id,k1) + idf_weight*idf_weight;
        end
        
    end
    
    for k2 = 1:image_size
        if(l2_norm(k2) > 0)
            result_score(k2,k1) = result_score(k2, k1) / l2_norm(k2);
        end
    end
    
    [result_score(:,k1), result_list(:,k1) ] = sort(result_score(:,k1),'descend'); 
end

