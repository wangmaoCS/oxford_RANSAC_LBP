function [match_points_ransac,opt_affine_mat] =  ransac_sp(feat1_all,feat2_all,match_points)

thre_scale = 20*20*2; %80:0.6533 60:0.654 50: 0.6539 40: 6544 ; 70:0.653
                      %baseline: 80:0.6524 60:0.65  doc

%match_points = match_points_tf(1:2,:);
                     
feat1 = feat1_all(:,match_points(1,:));
feat2 = feat2_all(:,match_points(2,:));

match_size  = size(match_points,2);
opt_affine_mat   = []; 
opt_inlier_idx   = [];

max_inlier_num   = 3;

for k1 = 1:match_size
    
    geo_info_q = feat1(:,k1);
    geo_info_d = feat2(:,k1);
    
    q_center = geo_info_q(1:2);
    a = geo_info_q(3);
    b = geo_info_q(4);
    c = geo_info_q(5);
    trans_h1   = [sqrt(a-b*b/c) 0; b/sqrt(c) sqrt(c)];
        
    d_center = geo_info_d(1:2);
    a = geo_info_d(3);
    b = geo_info_d(4);
    c = geo_info_d(5);
    trans_h2   = [sqrt(a-b*b/c) 0; b/sqrt(c) sqrt(c)];    
       
    trans_mat = trans_h2 \ trans_h1;
    trans_mat_inv = inv(trans_mat);

    %generate hypothesis
    %from query to target 
    trans_center  = trans_mat * q_center;     
    translat_vec  = d_center - trans_center;
    affine_mat    = [trans_mat translat_vec];
    
    %from target to query 
    trans_center_inv = trans_mat \ d_center;     
    translat_vec_inv = q_center - trans_center_inv;
    affine_mat_inv   = [trans_mat_inv translat_vec_inv];
    
    %determine inlier correspondences
    [inlier_match,inlier_idx]     = CalSupport(match_points,feat1(1:2,:),feat2(1:2,:),affine_mat,affine_mat_inv,thre_scale);    
    
%     %re-evaluating hypotheses using full transformation
         if(size(inlier_match,2) > max_inlier_num)            
            max_inlier_num = size(inlier_match,2);
                                     
            %from Multiple view geometry in computer vision, the H and inlier
            %can be get by spares LM algorithm
            
            %iteratively re-evaluating promising hypotheses 
            %using the full transforma-tion
            [full_affine_mat, full_inlier_idx] = Eva_FullTransform(feat1(1:2,:),feat2(1:2,:), inlier_idx,thre_scale);

            %test if the optimization results.
            if(size(full_inlier_idx,2) > size(opt_inlier_idx,2))
               opt_affine_mat = full_affine_mat;
               opt_inlier_idx = full_inlier_idx;
            end        
         end         
end

match_points_ransac = match_points(:,opt_inlier_idx);

