function match_par  = cal_par(feat1,feat2, match_point)

feat1 = feat1(:,match_point(1,:));
feat2 = feat2(:,match_point(2,:));

match_size  = size(match_point,2);
match_par   = zeros(3,match_size);

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
     
%     q_length_Area = sqrt( 1 / (q_a*q_c-q_b*q_b) );
%     d_length_Area = sqrt( 1 / (d_a*d_c-d_b*d_b) );    
%     delta_scale = d_length_Area / q_length_Area;
    
    q_length_gravityVector = -log10(curr_qGeo(5))/2;
    d_length_gravityVector = -log10(curr_dGeo(5))/2;
    delta_scale_vec = d_length_gravityVector - q_length_gravityVector;
    
%     q_length_gravityVector = sqrt(1 / curr_qGeo(5));
%     d_length_gravityVector = sqrt(1 / curr_dGeo(5));    
%     delta_scale_vec = d_length_gravityVector / q_length_gravityVector;
    
    Mi = [feat1(3,k1) feat1(4,k1); feat1(4,k1) feat1(5,k1)];
    [v, ~]=eig(Mi);
    q_alpha=atan2(v(4),v(3));
    
    d_Mi = [feat2(3,k1) feat2(4,k1); feat2(4,k1) feat2(5,k1)];
    [d_v, ~]=eig(d_Mi);
    d_alpha=atan2(d_v(4),d_v(3));
    delta_angle = d_alpha - q_alpha;
    
    match_par(1,k1) = delta_scale;
    match_par(2,k1) = delta_scale_vec;
    match_par(3,k1) = delta_angle; 
    
 end