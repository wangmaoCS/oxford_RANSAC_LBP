oxbuild_data   = '/home/401/Documents/public_data/INRIA_DATA/ICCV2013/';

%load data 
sift_fname     = [oxbuild_data 'oxford_sift.uint8'];
nsift_fname    = [oxbuild_data 'oxford_nsift.uint32'];
sift_geo_fname = [oxbuild_data 'oxford_geom_sift.float'];
gnd_fname      = [oxbuild_data 'gnd_oxford.mat'];
codebook_path  = [oxbuild_data 'clust_preprocessed/paris_codebook.fvecs'];
%vw_path        = [oxbuild_data 'clust_preprocessed/oxford_vw.int32'];

%load oxford sift data
desc_d = 128;
vtest = load_ext(sift_fname, desc_d);

%load clustering data, clustering on Oxford dataset
codebook = load_ext(codebook_path , 128);  %128*n_center

%load desc mean data, train on Oxford dataset
load('data/train_oxford_mean.mat');

%quantization 
nsift = size(vtest,2);
vwtest = zeros(1,nsift);

slice = 1000;
lastid = 0;
for k1 = 1:nsift
    
    curr_vtest = desc_postprocess_iccv2013(vtest(:,lastid+(1:slice)), vtrain_mean);
    [vwtest(lastid + (1:slice)), ~] = yael_nn(codebook,curr_vtest);
    
    lastid = lastid + slice;
    if(lastid / 10000 == round(lastid/10000))
        disp(lastid);
    end
    
    if(lastid+slice > nsift)
        slice = nsift - lastid;
        curr_vtest = desc_postprocess_iccv2013(vtest(:,lastid+(1:slice)), vtrain_mean);        
        [vwtest(lastid + (1:slice)), ~] = yael_nn(codebook,curr_vtest);
        break;
    end
    
end