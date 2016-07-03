
addpath('utils/');
addpath('vgg_multiview');

oxbuild_data   = '/home/401/Documents/public_data/INRIA_DATA/ICCV2013/';

%load data 
sift_fname     = [oxbuild_data 'oxford_sift.uint8'];
nsift_fname    = [oxbuild_data 'oxford_nsift.uint32'];
sift_geo_fname = [oxbuild_data 'oxford_geom_sift.float'];
gnd_fname      = [oxbuild_data 'gnd_oxford.mat'];
codebook_path  = [oxbuild_data 'clust_preprocessed/oxford_codebook.fvecs'];
%vw_path        = [oxbuild_data 'clust_preprocessed/oxford_vw.int32'];
vw_path        = ['data/' 'oxford_specific_codebook.int32'];
%load  groud truth
load(gnd_fname);

%load sift data
desc_d = 128;
%X = load_ext(sift_fname, desc_d); 

%load sift geo data
Xgeom = load_ext(sift_geo_fname, 5); %5*n_feat

%compute sift index of images;
ndes = load_ext(nsift_fname);
sl_nim = length(ndes);  
cndes = [0 cumsum(double(ndes))];  %1*n_image

%load clustering data
codebook = load_ext(codebook_path , 128);  %128*n_center
vw_data  = load_ext(vw_path);  %1*n_feat
codebook_size = size(codebook , 2);

%build invert index and cal idf 
% [invert_index, idf_value,l2_norm] = build_invertIndex(vw_data,cndes,codebook_size);
% save('data/invert_index.mat','invert_index');
% save('data/idf_value.mat','idf_value');
% save('data/l2_norm.mat','l2_norm');

load('data/invert_index.mat');
load('data/idf_value.mat');
load('data/l2_norm.mat');

%query...
tic
[result_list, ~] = query_image(vw_data, cndes,qidx, invert_index,idf_value,l2_norm);
toc

%cacluate ap
[map, aps,result_flag] = compute_map_select (result_list, gnd);
%save('result_data/bow_result_671.mat','aps','map','result_flag','result_list');

%save match feature 
rerank_size = 1000;

% the best map
% tmp_result_list = result_list;
% for k1 = 1:size(qidx,1)
%     [~, result_flag_idx] = sort(result_flag(1:rerank_size+1,k1),'descend');
%     tmp_result_list(1:rerank_size+1,k1) = result_list(result_flag_idx,k1);
% end %200:0.72, 1000:0.85
% [map, aps,~] = compute_map_select (tmp_result_list, gnd);
 
% tic;
% disp('search match set...');
% match_set = retrieve_match_feature(vw_data,cndes,qidx, invert_index, result_list(2:rerank_size+1,:));
% save('result_data/match_set_1k.mat','match_set');
% toc;
load('result_data/match_set_1k.mat');

img_dir = '/home/401/Documents/public_data/VGG_DATA/oxbuild_images/';
query_size = size(qidx,1);
image_size = length(imlist);

all_rerank_idx = zeros(rerank_size,query_size);

burst_data = cell(1,query_size);

% all_match_ransac = cell(rerank_size,query_size);
% all_opt_matrix   = cell(rerank_size,query_size);
load('tmp_ransac_data.mat');

tic
for k1 = 1:query_size
    
    %img1 = imread([ img_dir imlist{qidx(k1)} '.jpg']);
    feat1 = Xgeom(:,cndes(qidx(k1))+1 : cndes(qidx(k1)+1));
    vw1   = vw_data(:,cndes(qidx(k1))+1 : cndes(qidx(k1)+1));
    rerank_score = zeros(rerank_size,1);
    
    tmp_burst_data = zeros(rerank_size,2);
    
    for k2 = 1:rerank_size  %41

        %img2 = imread([ img_dir imlist{result_list(k2+1,k1)} '.jpg']);
        feat2 = Xgeom(:,cndes(result_list(k2+1,k1))+1 : cndes(result_list(k2+1,k1)+1));
        vw2   = vw_data(:,cndes(result_list(k2+1,k1))+1 : cndes(result_list(k2+1,k1)+1));
        
        match_point = match_set{k2,k1};
        %disp_match_features_vgg(img1,img2,feat1,feat2,match_point);    
        
        %[match_point_ransac,opt_aff_matrix] = ransac_sp(feat1,feat2,match_point);
        %all_match_ransac{k2,k1} = match_point_ransac;
        %all_opt_matrix{k2,k1}   = opt_aff_matrix;
        match_point_ransac = all_match_ransac{k2,k1};
        opt_aff_matrix     = all_opt_matrix{k2,k1};
        
        %disp_match_features_vgg(img1,img2,feat1,feat2,match_point_ransac)%
        %match_par  = cal_par(feat1,feat2, match_point_ransac);
        
        [match_point_ransac, area_ratio] = Filter_area(feat1,feat2,match_point_ransac,opt_aff_matrix,5.5); %6:7824
        %disp_match_features_vgg(img1,img2,feat1,feat2,match_point_ransac);
        
%         (det(opt_aff_matrix))
%         mean(area_ratio)
%         std(area_ratio)
        
%         if(det(opt_aff_matrix) > 10 || det(opt_aff_matrix) < 0.1)
%             img2 = imread([ img_dir imlist{result_list(k2+1,k1)} '.jpg']);
%             disp_match_features_vgg(img1,img2,feat1,feat2,match_point_ransac);
%             disp(det(opt_aff_matrix));
%             disp(k2);
%         end

        match_num = size(match_point_ransac,2);
        if( match_num > 0 ) 
                        
            [unq_vw,~] = unique(vw1(match_point_ransac(1,:)));
            unq_vw_size = size(unq_vw,2);
            cur_vw_size = size(match_point_ransac,2);
            burst_ratio = unq_vw_size / cur_vw_size;
            
            if(match_num < 100  )
                
                match_point_ransac = OneV1Match(match_point_ransac, vw1, idf_value);
                %disp_match_features_vgg(img1,img2,feat1,feat2,match_point_ransac);
                                
                local_vw_size = zeros(2,codebook_size);
                for k3 = 1: size(match_point_ransac,2)
                        local_vw_size(1,vw1(match_point_ransac(1,k3))) =  local_vw_size(1,vw1(match_point_ransac(1,k3))) +1;
                        local_vw_size(2,vw2(match_point_ransac(2,k3))) =  local_vw_size(2,vw2(match_point_ransac(2,k3))) +1;
                end
                local_tf = local_vw_size(1, vw2(match_point_ransac(2,:)));%.* local_vw_size(1, vw1(match_point_ransac(1,:))) ;                
                local_idf =  idf_value(vw1(match_point_ransac(1,:))) ;

                %scoremap =  1 ./ ( 2*(local_tf') - 0);  %0.7814
                scoremap =  1 ./ ( 1*sqrt(local_tf') + 0);  %0.7815
                scoremap(local_tf < 3)  = 1;
                
                tmp_score = sqrt(local_idf) .* scoremap;
                rerank_score(k2) = sum( tmp_score );                 
            else 
                tmp_score = sqrt(idf_value(vw1(match_point_ransac(1,:))));
                rerank_score(k2) = sum(tmp_score);   
                                                
            end
                        
            %rerank_score(k2) = sum(idf_value(vw1(match_point_ransac(1,:))));            
        end
        
    end
    
    [~,rerank_idx]   = sort(rerank_score,'descend');
    all_rerank_idx(:,k1) = rerank_idx;
    tmp_result      = result_list(2:rerank_size+1,k1);
    result_list(2:rerank_size+1,k1) = tmp_result(rerank_idx);
    disp(k1);
end
toc

[map_rerank, aps_rerank,rerank_flag] = compute_map_select (result_list, gnd);
rerank_flag = rerank_flag(2:rerank_size+1,:);
%save('result_data/bow_ransac_1v1_1k_776_less100.mat','rerank_flag','all_rerank_idx','aps_rerank', 'map_rerank');
%sort(vw1(match_point_ransac_1v1(1,:)));
%save('tmp_ransac_data.mat','all_match_ransac','all_opt_matrix');