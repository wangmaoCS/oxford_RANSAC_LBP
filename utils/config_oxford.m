% Return a config object that contains all the paths for the Oxford dataset
% as well as the groundtruth

function cfg = config_oxford (params)

% Default parameters
cfg = config (params);
cfg.desc_nlearn = 5000000;

% Load groundtruth
cfg.gnd_fname = [cfg.dir_data 'gnd_oxford5k.mat'];
load (cfg.gnd_fname); % Retrieve list of image names, ground truth and query numbers

% Specific variables to handle Oxford's groundtruth
cfg.imlist = imlist;
cfg.gnd = gnd;
cfg.qidx = qidx;

cfg.n = length (cfg.imlist);   % number of database images
cfg.nq = length (cfg.qidx);    % number of query images

cfg.nslices = ceil (cfg.n / cfg.slice_size);

% Training data descriptors for Paris6k dataset
% Provided by CVUT (Prague)
cfg.train_sift_fname = [cfg.dir_data 'paris_sift.uint8'];

% files storing descriptors/geometry for Oxford5k dataset
% Provided by CVUT (Prague)
cfg.test_sift_fname = [cfg.dir_data 'oxford_sift.uint8'];
cfg.test_geom_fname = [cfg.dir_data 'oxford_geom_sift.float'];
cfg.test_nf_fname = [cfg.dir_data 'oxford_nsift.uint32'];

cfg.cropquery = @config_oxford_cropquery;

%-------------------------------------
function idx = config_oxford_cropquery (cfg, qi, xy)
bbx = cfg.gnd(qi).bbx;
idx = find( xy(1, :)>bbx(1) & xy(1, :)<bbx(3) & xy(2, :)>bbx(2) & xy(2, :)<bbx(4) );
