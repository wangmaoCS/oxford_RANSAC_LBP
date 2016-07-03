function [inlier_match,inlier_idx]     = CalSupport(match_points,centers_query,centers_database,affine_mat,affine_mat_inv,thre_scale)

num_match   =  size(match_points,2);

scale_rot_mat       = affine_mat(:,1:2);
translat_mat        = affine_mat(:,3);
transf_centers      = scale_rot_mat * centers_query;
transf_centers      = transf_centers + repmat(translat_mat,1,num_match);
diff_query2database = transf_centers - centers_database;
dist_query2database = sum(diff_query2database .* diff_query2database);

scale_rot_mat_inv   = affine_mat_inv(:,1:2);
translat_mat_inv    = affine_mat_inv(:,3);
transf_centers_inv  = scale_rot_mat_inv * centers_database;
transf_centers_inv  = transf_centers_inv + repmat(translat_mat_inv,1,num_match);
diff_database2query = transf_centers_inv - centers_query;
dist_database2query = sum(diff_database2query .* diff_database2query);

two_way_dis  = dist_query2database + dist_database2query;
inlier_idx   = find(two_way_dis < thre_scale);
inlier_match = match_points(:,two_way_dis < thre_scale);