function [match_points, area_ratio_new] = Filter_area(feat1,feat2,match_points,opt_aff_matrix,threshold)

global_scale = log2(det(opt_aff_matrix));

feat1 = feat1(:,match_points(1,:));
feat2 = feat2(:,match_points(2,:));
match_size  = size(match_points,2);

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
    q_length_Area = -log2(q_a*q_c-q_b*q_b)/2;
    d_length_Area = -log2(d_a*d_c-d_b*d_b)/2;    
    delta_scale = d_length_Area - q_length_Area;

    area_ratio(k1) = delta_scale;
end

index =  abs((area_ratio)-(global_scale)) <= log2(threshold);
match_points = match_points(:,index);
area_ratio_new = area_ratio(index);

