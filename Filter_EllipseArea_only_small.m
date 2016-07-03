function [match_points_scale,max_idx,area_ratio]  = Filter_EllipseArea_only_small(feat1,feat2,match_points)

feat1 = feat1(:,match_points(1,:));
feat2 = feat2(:,match_points(2,:));

n_scale_bin = 16; 

max_scale = 2;
min_scale = -2; 
scale_step  = (max_scale-min_scale) / n_scale_bin; %[-2 2]

match_size  = size(match_points,2);
hist_grid   = zeros(1,n_scale_bin);
hv_flag     = zeros(1,match_size);

area_ratio  = zeros(match_size,1);

for k1 = 1:match_size
    curr_qGeo = feat1(:,k1);    %3,4,5 : a,b,c
    curr_dGeo = feat2(:,k1);
    q_a = curr_qGeo(3);
    q_b = curr_qGeo(4);
    q_c = curr_qGeo(5);    
    d_a = curr_dGeo(3);
    d_b = curr_dGeo(4);
    d_c = curr_dGeo(5);    
    q_length_Area = -log10(q_a*q_c-q_b*q_b)/2;
    d_length_Area = -log10(d_a*d_c-d_b*d_b)/2;    
    delta_scale = d_length_Area - q_length_Area;

    area_ratio(k1) = 10 ^ delta_scale;
    
    if((delta_scale >= min_scale && delta_scale <= max_scale))
        s_idx = floor( (delta_scale - min_scale) / scale_step ) + 1;      
        hv_flag(k1)  = s_idx;
        hist_grid(s_idx) = hist_grid(s_idx) + 1;
    end   
end
% [~,max_idx] = max(hist_grid);
% if(max_idx > 1)
%     hv_flag(hv_flag == max_idx-1) = max_idx;
% end
% if(max_idx < n_scale_bin)
%     hv_flag(hv_flag == max_idx+1) = max_idx;
% end
 
hist_grid_new = zeros(1,n_scale_bin);
hist_grid_new(1) = sum(hist_grid(1:2)) /2;
hist_grid_new(n_scale_bin) = sum(hist_grid(end-1:end)) /2;
for k1 = 2:n_scale_bin-1
   hist_grid_new(k1) = sum(hist_grid(k1-1:k1+1) ) /3;       
end

[~,max_idx] = max(hist_grid_new);
if(max_idx > 1)
    hv_flag(hv_flag == max_idx-1) = max_idx;
end
if(max_idx < n_scale_bin)
    hv_flag(hv_flag == max_idx+1) = max_idx;
end


match_points_scale = match_points(:,hv_flag==max_idx ); %find the max bin