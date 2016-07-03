% Apply some post-processing operations 
% Usage: x = desc_postprocess (x)
%  x          descriptors
%  nr_thres   optional. Filter descriptors based on norm (0 does nothing)
%  desc_mean  optional. Remove the mean 
function [x, desc_mean, nin, nout] = desc_postprocess (x, nr_thres, desc_mean)

nin = size(x, 2);

% filter based on norm
if exist('nr_thres')
  vtnr = sum(x.^2, 1);

  posok = find (vtnr >= nr_thres^2);
  x = x(:, posok);
  nout = size(x, 2);
else nout = nin;
end

x = single (x);
x = x.^0.5; % root-sift

% Subtract mean, otherwise compute it
if ~exist('desc_mean')
  desc_mean = mean (x, 2);
end

x = bsxfun (@minus, x, desc_mean);

%x = yael_vecs_normalize (x); % L2 normalize

for k = 1:size(x,2) 
    tmp_x = x(:,k);
    x(:,k) = tmp_x / norm(tmp_x,2);
end