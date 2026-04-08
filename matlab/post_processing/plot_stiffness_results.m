function plot_stiffness_results(descriptors, stats, results_dir)
% PLOT_STIFFNESS_RESULTS  Generate summary plots for the post-processing
%                          stage of the EV freeze-thaw stiffness study.
%
%   PLOT_STIFFNESS_RESULTS(descriptors, stats, results_dir)

if nargin < 3 || isempty(results_dir)
    results_dir = 'results';
end
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

labels    = {descriptors.label};
disp_vals = [descriptors.displacement];
vol_vals  = [descriptors.volume_change];
x         = 1:numel(descriptors);

% ---- Figure: Displacement with mean reference line ------------------
fig = figure('Visible', 'off', 'Position', [100 100 800 400]);

subplot(1, 2, 1);
bar(x, disp_vals, 'FaceColor', [0.2 0.5 0.8]);
hold on;
yline(stats.mean_displacement, '--r', sprintf('Mean = %.2f mm', stats.mean_displacement), ...
      'LineWidth', 1.5, 'LabelHorizontalAlignment', 'left');
set(gca, 'XTick', x, 'XTickLabel', labels);
xlabel('Sample');
ylabel('Mean displacement (mm)');
title('Point Displacement after Freeze-Thaw');
grid on;

subplot(1, 2, 2);
bar(x, vol_vals, 'FaceColor', [0.8 0.4 0.2]);
hold on;
yline(0, '-k', 'LineWidth', 1);
yline(stats.mean_volume_change, '--r', sprintf('Mean = %.2f %%', stats.mean_volume_change), ...
      'LineWidth', 1.5, 'LabelHorizontalAlignment', 'left');
set(gca, 'XTick', x, 'XTickLabel', labels);
xlabel('Sample');
ylabel('Volume change (%)');
title('Volume Change after Freeze-Thaw');
grid on;

sgtitle('EV Component Stiffness – Freeze-Thaw Summary');

saveas(fig, fullfile(results_dir, 'stiffness_summary.png'));
close(fig);
fprintf('Stiffness summary plot saved to: %s\n', results_dir);
end
