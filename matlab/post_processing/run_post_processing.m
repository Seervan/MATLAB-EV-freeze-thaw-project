function run_post_processing()
% RUN_POST_PROCESSING  Entry point for EV freeze-thaw post-processing.
%
%   Loads processed shape descriptors, computes summary statistics, and
%   produces publication-ready plots saved to the results/ directory.
%
%   Usage:
%       run_post_processing()
%
%   See also: compute_summary_stats, plot_stiffness_results

fprintf('=== EV Freeze-Thaw Post-Processing ===\n');

% ------------------------------------------------------------------
% 1. Configuration
% ------------------------------------------------------------------
processed_dir = fullfile('data', 'processed');
results_dir   = 'results';

if ~exist(results_dir, 'dir'), mkdir(results_dir); end

% ------------------------------------------------------------------
% 2. Load processed shape descriptors
% ------------------------------------------------------------------
desc_file = fullfile(processed_dir, 'shape_descriptors.mat');

if ~exist(desc_file, 'file')
    warning('run_post_processing:noData', ...
        'Processed data not found: %s\nRun run_shape_analysis() first.', ...
        desc_file);
    return
end

loaded      = load(desc_file, 'descriptors');
descriptors = loaded.descriptors;

% ------------------------------------------------------------------
% 3. Summary statistics
% ------------------------------------------------------------------
stats = compute_summary_stats(descriptors);
fprintf('Summary statistics:\n');
fprintf('  Mean displacement : %.4f mm\n', stats.mean_displacement);
fprintf('  Std displacement  : %.4f mm\n', stats.std_displacement);
fprintf('  Mean volume change: %.4f %%\n', stats.mean_volume_change);

% ------------------------------------------------------------------
% 4. Save summary
% ------------------------------------------------------------------
stats_file = fullfile(results_dir, 'summary_stats.mat');
save(stats_file, 'stats');
fprintf('Summary statistics saved to: %s\n', stats_file);

% ------------------------------------------------------------------
% 5. Plots
% ------------------------------------------------------------------
plot_stiffness_results(descriptors, stats, results_dir);

fprintf('Post-processing complete.\n');
end
