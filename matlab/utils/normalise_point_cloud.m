function pts_out = normalise_point_cloud(pts)
% NORMALISE_POINT_CLOUD  Centre and unit-scale a 3-D point cloud.
%
%   pts_out = NORMALISE_POINT_CLOUD(pts)
%
%   Subtracts the centroid and divides by the maximum extent so that the
%   output fits inside a unit cube centred on the origin.
%
%   Input:
%       pts     - (N x 3) matrix of 3-D coordinates
%   Output:
%       pts_out - normalised (N x 3) matrix

centroid = mean(pts, 1);
pts_c    = pts - centroid;
scale    = max(vecnorm(pts_c, 2, 2));

if scale == 0
    warning('normalise_point_cloud:zeroScale', ...
            'All points are identical – returning zero matrix.');
    pts_out = zeros(size(pts));
    return
end

pts_out = pts_c / scale;
end
