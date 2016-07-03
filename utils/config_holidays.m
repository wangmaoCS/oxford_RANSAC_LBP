% Return a config object that contains all the paths for the Holidays dataset
% as well as the groundtruth

function cfg = config_holidays (params)

% Default parameters
cfg = config (params);
cfg.desc_nlearn = 5000000;

% Load groundtruth
cfg.gnd_fname = [cfg.dir_data 'gnd_holidays.mat'];
load (cfg.gnd_fname); % Retrieve list of image names, ground truth and query numbers

% Specific variables to handle Holidays' groundtruth
cfg.imlist = imlist;
cfg.gnd = gnd;
cfg.qidx = qidx;

cfg.n = length (cfg.imlist);   % number of database images
cfg.nq = length (cfg.qidx);    % number of query images

cfg.slice_size = 1491;
cfg.nslices = 1;

% hessian-affine descriptors
cfg.test_sift_fname = [cfg.dir_data 'holidays_sift.uint8'];
cfg.test_geom_fname = [cfg.dir_data 'holidays_geom_sift.float'];
cfg.test_nf_fname = [cfg.dir_data 'holidays_nsift.int32'];


% Files for learning
cfg.siftraw_sample = [cfg.dir_data 'flickr60k.siftgeo'];
cfg.train_sift_fname = cfg.siftraw_sample;

cfg.cropquery = @config_holidays_cropquery;

%-------------------------------------
function idx = config_holidays_cropquery (cfg, qi, xy)
idx = 1:size(xy, 2);
