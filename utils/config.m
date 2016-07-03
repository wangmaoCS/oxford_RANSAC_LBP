function cfg = config (params)

% default parameters
cfg.k = 16;
cfg.desc_d = 128;           % dimensionality of the descriptor (on disk)
cfg.desc_dd = 128;          % dimensionality after PCA
cfg.geom_d = 4; 						% dimensionality of geometry information
cfg.lopt = '';
cfg.desc_nlearn = 5000000;  % number of descriptors for learning on local descriptors
cfg.n = 0;                  % number of database images
cfg.nq = 0;                 % number of query images

cfg.imlist = {};            % image list (cell of strings)

cfg.lopt = '';
cfg.det_type = 'hesaff_norm';
cfg.desc_type = 'sift';

cfg.ndes = 0;        % number of local descriptors for each image
cfg.cndes = [0 0];   % cumulative nb

cfg.slice_size = 200;

% Override the default parameters defined above above
if nargin == 1
  fields = fieldnames(params);
  for fi = 1:length(fields)
    f = fields{fi};
    cfg = setfield(cfg,f,getfield(params,f));
  end
end

cfg.des_type = [cfg.det_type '_' cfg.desc_type];

if ~strcmp (cfg.det_type, 'hesaff_norm')
  cfg.lopt = sprintf ('%s_%s', cfg.lopt, cfg.det_type);
end

if ~strcmp (cfg.desc_type, 'sift')
  cfg.lopt = sprintf ('%s_%s', cfg.lopt, cfg.desc_type);
end

% All Sifts and geom concatenated in two files
cfg.siftgeom_fname = sprintf ('%s/%s_geom.%%d.float', cfg.dir_data, cfg.des_type);
cfg.siftraw_fname =  sprintf ('%s/%s_raw.%%d.uint8', cfg.dir_data, cfg.des_type);
cfg.nldes_fname = sprintf ('%s/%s_nldes.%%d.int32', cfg.dir_data, cfg.des_type);

% Utils
cfg.slice_info = @config_slice_info;


%-------------------------------------
function [sl_start, sl_end, sl_nim, ndes, cndes] = config_slice_info (cfg, sli)
sl_start = (sli - 1) * cfg.slice_size + 1;
sl_end = sli * cfg.slice_size;
if sl_end > cfg.n, sl_end = cfg.n ; end
sl_nim = sl_end - sl_start + 1;

if nargout > 3
  ndes = double(load_ext (sprintf (cfg.nldes_fname, sli)));
  cndes = [0 cumsum(ndes)];
end
