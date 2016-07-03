function  match_set = retrieve_match_feature(vw_data,cndes,qidx, invert_index, rerank_list)

 query_size  = size(rerank_list,2);
 rerank_size = size(rerank_list,1);
 match_set   = cell(rerank_size,query_size);

for k1 = 1:query_size
        
    for k4 = 1:rerank_size 
        
        rerank_img = rerank_list(k4,k1);
        match_info = [];
    
        q_vw_code = vw_data(cndes(qidx(k1))+1:cndes(qidx(k1) + 1)); 
       
       for k2 = 1:size(q_vw_code,2)
            invert_list = invert_index{q_vw_code(k2)};
            for k3 = 1:size(invert_list,2)
                image_id = invert_list(1,k3);                                            
                if(image_id == rerank_img)                    
                    match_node = [k2;invert_list(2,k3)];
                    match_info = [match_info match_node];                    
                end
            end
       end

       match_set{k4,k1} = match_info;   
    end
      
end