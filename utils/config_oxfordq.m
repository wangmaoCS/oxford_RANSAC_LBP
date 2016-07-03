% Creates config structure with filenames of data
% The function optionally take a path to specify where data is stord
function cfg = config_oxfordq (params)

% Default parameters
cfg = config (params);

cfg = struct;
cfg.desc_d = 128;
cfg.desc_nlearn = 5000000;
cfg.n = 55;


% Override the default parameters defined above above
if nargin == 1
  fields = fieldnames(params);
  for fi = 1:length(fields)
    f = fields{fi};
    cfg = setfield(cfg,f,getfield(params,f));
  end
end


if ~isfield (cfg, 'dir_data')
  cfg.dir_data = './data/';
end

% Training data descriptors for Paris6k dataset
% Provided by CVUT (Prague)
cfg.train_sift_fname = [cfg.dir_data 'paris_sift.uint8'];

% files storing descriptors/geometry for Oxford5k dataset
% Provided by CVUT (Prague)
cfg.test_sift_fname = [cfg.dir_data 'oxford_sift.uint8'];
cfg.test_geom_fname = [cfg.dir_data 'oxford_geom_sift.float'];
cfg.test_nf_fname = [cfg.dir_data 'oxford_nsift.uint32'];

% Ground-truth for Oxford dataset
cfg.gnd_fname =  [cfg.dir_data 'gnd_oxford.mat'];

% Only one slide for Oxford
cfg.nslices = 1;
