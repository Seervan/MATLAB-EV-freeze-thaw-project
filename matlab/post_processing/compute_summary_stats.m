function stats = compute_summary_stats(descriptors)
% COMPUTE_SUMMARY_STATS  Compute summary statistics from shape descriptors.
%
%   stats = COMPUTE_SUMMARY_STATS(descriptors)
%
%   Input:
%       descriptors - struct array produced by compute_shape_descriptors
%
%   Output:
%       stats - struct with fields:
%                 .mean_displacement  : mean of per-sample mean displacements
%                 .std_displacement   : std  of per-sample mean displacements
%                 .mean_volume_change : mean volume change across samples (%)
%                 .std_volume_change  : std  volume change across samples (%)
%                 .n_samples          : number of samples

disp_vals = [descriptors.displacement];
vol_vals  = [descriptors.volume_change];

stats.mean_displacement  = mean(disp_vals,  'omitnan');
stats.std_displacement   = std(disp_vals,   'omitnan');
stats.mean_volume_change = mean(vol_vals,   'omitnan');
stats.std_volume_change  = std(vol_vals,    'omitnan');
stats.n_samples          = numel(descriptors);
end
