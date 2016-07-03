function oneMatch = OneV1Match(match_points,vwCode,idf_value)

    newMap = containers.Map('KeyType','double','ValueType', 'any');
    
    for k1 = 1: size(match_points,2)
        curr_key = match_points(1,k1);
        curr_val = match_points(2,k1);
       if(isKey(newMap,curr_key))
          newMap(curr_key) = [newMap(curr_key) curr_val];
       else
          newMap(curr_key) = curr_val; 
       
       end
    end
    
    oneMatch = [];    
    max_itr = length(newMap) ;
    for k1 = 1:max_itr 
        if(length(newMap) == 0)
            break;
        end
        all_key = keys(newMap);
        all_val = values(newMap);    
        min_matchSize = 100;
        for k2 = 1:length(newMap)  %find the min match size
            if(length(all_val{k2}) < min_matchSize)
               min_matchSize = length(all_val{k2});
               min_matchKey  = all_key{k2};
            end
        end
                
        curr_max_idf = idf_value(vwCode(min_matchKey));
        if(min_matchSize == 1) % find the min idf value 
            for k2 = 1:length(newMap)  %find the min match size
                if(length(all_val{k2}) == min_matchSize)
                    curr_idf = idf_value(vwCode(all_key{k2}));
                    if(curr_idf > curr_max_idf)
                        curr_max_idf = curr_idf;
                        min_matchKey  = all_key{k2};
                    end
                end
            end 
        end
                
        select_match = newMap(min_matchKey);
        if(size(select_match,2) > 1)
            select_match = select_match(1);
        end
        oneMatch = [oneMatch [min_matchKey ; select_match]]; % save selected
        remove(newMap, min_matchKey);
        
        all_key = keys(newMap);
        all_val = values(newMap);
        for k2 = 1:length(newMap)  %delete match corrpondence
            idx = (all_val{k2} ~= select_match);
            if(idx == 0)
                remove(newMap,all_key{k2});
            else
                newMap(all_key{k2}) = all_val{k2}(idx);
            end
        end
    end
    
    
final_match_size = size(oneMatch,2);
final_match_q    = unique(oneMatch(1,:));
final_match_qSize = length(final_match_q);

final_match_m    = unique(oneMatch(2,:));
final_match_mSize = length(final_match_m);

if(final_match_size ~= final_match_qSize)
    fprintf('error\n');
end

if(final_match_mSize ~= final_match_qSize)
    fprintf('error\n');
end