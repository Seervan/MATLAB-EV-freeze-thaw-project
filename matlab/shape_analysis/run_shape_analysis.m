function run_shape_analysis()
% RUN_SHAPE_ANALYSIS  Entry point for EV component shape characterisation.
%
%   Loads experimental measurement data, computes geometric shape
%   descriptors before and after freeze-thaw cycling, and saves the
%   results to the data/processed/ directory.
%
%   Usage:
%       run_shape_analysis()
%
%   See also: compute_shape_descriptors, plot_shape_comparison

fprintf('=== EV Freeze-Thaw Shape Analysis ===\n');

% ------------------------------------------------------------------
% 1. Configuration
% ------------------------------------------------------------------
raw_data_dir  = fullfile('data', 'raw');
out_dir       = fullfile('data', 'processed');
results_dir   = 'results';

if ~exist(out_dir, 'dir'),     mkdir(out_dir);     end
if ~exist(results_dir, 'dir'), mkdir(results_dir); end

% ------------------------------------------------------------------
% 2. Load data
%    Replace the example filename with your actual measurement file.
% ------------------------------------------------------------------
example_file = fullfile(raw_data_dir, 'measurements.mat');

if ~exist(example_file, 'file')
    warning('run_shape_analysis:noData', ...
        'Example data file not found: %s\nPlease place your measurement data in the data/raw/ directory.', ...
        example_file);
    return
end

loaded = load(example_file);   % expects struct with field 'measurements'
measurements = loaded.measurements;

% ------------------------------------------------------------------
% 3. Compute shape descriptors
% ------------------------------------------------------------------
descriptors = compute_shape_descriptors(measurements);

% ------------------------------------------------------------------
% 4. Save results
% ------------------------------------------------------------------
out_file = fullfile(out_dir, 'shape_descriptors.mat');
save(out_file, 'descriptors');
fprintf('Shape descriptors saved to: %s\n', out_file);

% ------------------------------------------------------------------
% 5. Plot comparison
% ------------------------------------------------------------------
plot_shape_comparison(descriptors, results_dir);

fprintf('Shape analysis complete.\n');
end
