function descriptors = compute_shape_descriptors(measurements)
% COMPUTE_SHAPE_DESCRIPTORS  Compute geometric shape descriptors from
%                             measurement data.
%
%   descriptors = COMPUTE_SHAPE_DESCRIPTORS(measurements)
%
%   Input:
%       measurements  - struct array with fields:
%                         .pre   : (N x 3) point cloud before freeze-thaw
%                         .post  : (N x 3) point cloud after freeze-thaw
%                         .label : string identifier for the sample
%
%   Output:
%       descriptors   - struct array with fields:
%                         .label        : sample identifier
%                         .pre_centroid : centroid of pre-cycle shape
%                         .post_centroid: centroid of post-cycle shape
%                         .displacement : mean displacement (mm)
%                         .volume_change: estimated volume change (%)

n = numel(measurements);
descriptors(n) = struct( ...
    'label',         '', ...
    'pre_centroid',  [], ...
    'post_centroid', [], ...
    'displacement',  0,  ...
    'volume_change', 0);

for i = 1:n
    pre  = measurements(i).pre;
    post = measurements(i).post;

    descriptors(i).label         = measurements(i).label;
    descriptors(i).pre_centroid  = mean(pre,  1);
    descriptors(i).post_centroid = mean(post, 1);
    descriptors(i).displacement  = mean(vecnorm(post - pre, 2, 2));
    descriptors(i).volume_change = estimate_volume_change(pre, post);
end
end

% -----------------------------------------------------------------------
function dv = estimate_volume_change(pre, post)
% ESTIMATE_VOLUME_CHANGE  Rough volume-change estimate using convex hulls.
%   Returns the percentage change: (V_post - V_pre) / V_pre * 100.

try
    [~, v_pre]  = convhull(pre(:,1),  pre(:,2),  pre(:,3));
    [~, v_post] = convhull(post(:,1), post(:,2), post(:,3));
    dv = (v_post - v_pre) / v_pre * 100;
catch
    dv = NaN;
end
end
