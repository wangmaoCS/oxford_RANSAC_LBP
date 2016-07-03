function curr_inlier_idx  = CalSupport_InAll(centers_query,centers_database,affine_mat,thre_scale)

num_match =  size(centers_query,2);

centers_query       = [centers_query; ones(1,num_match)];
centers_database       = [centers_database; ones(1,num_match)];

transf_centers      = affine_mat * centers_query;
diff_query2database = transf_centers - centers_database;
dist_query2database = sum(diff_query2database .* diff_query2database);

%affine_mat_inv      = inv(affine_mat);
transf_centers_inv  =  affine_mat \ centers_database ;
diff_database2query = transf_centers_inv - centers_query;
dist_database2query = sum(diff_database2query .* diff_database2query);

two_way_dis = dist_query2database + dist_database2query;
curr_inlier_idx  = find(two_way_dis < thre_scale);
%inlier_match = match_points(:,two_way_dis < thre_scale);