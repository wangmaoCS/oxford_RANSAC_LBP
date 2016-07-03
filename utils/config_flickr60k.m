% Creates config structure with filenames of data
% The function optionally take a path to specify where data is stord
function cfg = config_flickr60k (params)

% Default parameters
cfg = config (params);
cfg.desc_nlearn = 5000000;

% Load groundtruth
cfg.gnd_fname = [cfg.dir_data 'gnd_flickr60k.mat'];
load (cfg.gnd_fname); % Retrieve the list of image basenames

% Specific variables to handle Holidays' groundtruth
cfg.imlist = imlist;

cfg.n = length (cfg.imlist);   % number of database images

cfg.nslices = ceil (cfg.n / cfg.slice_size);

