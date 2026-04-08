function plot_shape_comparison(descriptors, results_dir)
% PLOT_SHAPE_COMPARISON  Generate bar charts comparing pre- and
%                         post-freeze-thaw shape descriptors.
%
%   PLOT_SHAPE_COMPARISON(descriptors, results_dir)
%
%   Inputs:
%       descriptors  - struct array produced by compute_shape_descriptors
%       results_dir  - directory path where figures will be saved

if nargin < 2 || isempty(results_dir)
    results_dir = 'results';
end
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

labels     = {descriptors.label};
disp_vals  = [descriptors.displacement];
vol_vals   = [descriptors.volume_change];

% ---- Figure 1: Mean displacement -----------------------------------
fig1 = figure('Visible', 'off');
bar(disp_vals);
set(gca, 'XTickLabel', labels, 'XTick', 1:numel(labels));
xlabel('Sample');
ylabel('Mean displacement (mm)');
title('Pre- vs Post-Freeze-Thaw: Mean Point Displacement');
grid on;
saveas(fig1, fullfile(results_dir, 'displacement_comparison.png'));
close(fig1);

% ---- Figure 2: Volume change ----------------------------------------
fig2 = figure('Visible', 'off');
bar(vol_vals);
set(gca, 'XTickLabel', labels, 'XTick', 1:numel(labels));
xlabel('Sample');
ylabel('Volume change (%)');
title('Pre- vs Post-Freeze-Thaw: Estimated Volume Change');
yline(0, '--r', 'LineWidth', 1.2);
grid on;
saveas(fig2, fullfile(results_dir, 'volume_change_comparison.png'));
close(fig2);

fprintf('Figures saved to: %s\n', results_dir);
end
