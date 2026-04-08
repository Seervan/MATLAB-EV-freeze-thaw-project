function out = load_measurement_file(filepath)
% LOAD_MEASUREMENT_FILE  Load a raw measurement file and validate its
%                         contents.
%
%   out = LOAD_MEASUREMENT_FILE(filepath)
%
%   Expects a .mat file containing a variable called 'measurements', which
%   must be a struct array with at least the fields:
%       .pre   (N x 3 double) – pre-cycle 3-D point cloud
%       .post  (N x 3 double) – post-cycle 3-D point cloud
%       .label (char)         – sample identifier
%
%   Returns the validated measurements struct array.

if ~exist(filepath, 'file')
    error('load_measurement_file:fileNotFound', ...
          'File not found: %s', filepath);
end

loaded = load(filepath);

if ~isfield(loaded, 'measurements')
    error('load_measurement_file:missingField', ...
          'The file does not contain a variable named ''measurements'': %s', filepath);
end

out = loaded.measurements;

% Basic validation
required_fields = {'pre', 'post', 'label'};
for k = 1:numel(required_fields)
    if ~isfield(out, required_fields{k})
        error('load_measurement_file:missingMeasurementField', ...
              'measurements struct is missing required field: %s', required_fields{k});
    end
end
end
