function [full_affine_mat, full_inlier_idx] = Eva_FullTransform(centers_query,centers_database,inlier_idx,thre_scale)

opt_inlier_num = 0;
curr_inlier_idx = inlier_idx;
full_affine_mat = [];
full_inlier_idx = [];

while(1)
    xs1 = centers_query(:, curr_inlier_idx);
    xs1 = [xs1 ; ones(1,size(xs1,2)) ];
    xs2 = centers_database(:, curr_inlier_idx);
    xs2 = [xs2 ; ones(1,size(xs2,2)) ];

    if(size(xs1,2) < 4)
        break;
    end
        
    q_maxstds = max(std(xs1'));
    d_maxstds = max(std(xs2'));
    if(q_maxstds == 0 || d_maxstds == 0)
        break;
    end
    
    % cal H matrix by using VGG hz book code
    curr_affine_mat  = vgg_Haffine_from_x_MLE(xs1,xs2);
    %full_affine_mat = vgg_H_from_x_lin(xs1,xs2);
    det_value = curr_affine_mat(1) * curr_affine_mat(5) - curr_affine_mat(2)*curr_affine_mat(4);
    if(det_value < 0.00001)
        break;
    end
    %det(curr_affine_mat)
    % estmiate the new hypothosis
    curr_inlier_idx  = CalSupport_InAll(centers_query,centers_database,curr_affine_mat,thre_scale);
    curr_inlier_num  = size(curr_inlier_idx,2);
    
    if(curr_inlier_num <= opt_inlier_num)
        break;
    else
        opt_inlier_num  = curr_inlier_num;
        full_affine_mat = curr_affine_mat;
        full_inlier_idx = curr_inlier_idx;
    end
end





%