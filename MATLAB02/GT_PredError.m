% Define the path to the directory where the .txt files are stored
dataDir = '/Users/ahmedhenine/Desktop/';  

% Define file names
groundTruthFile = fullfile(dataDir, 'ground_truth.txt');
innovationSequenceFile = fullfile(dataDir, 'innovation_sequence.txt');
predictionErrorsFile = fullfile(dataDir, 'prediction_errors.txt');

% Read the data from the text files
groundTruths = readmatrix(groundTruthFile);
innovationSequence = readmatrix(innovationSequenceFile);
predictionErrors = readmatrix(predictionErrorsFile);

% Display the sizes (shape) of the loaded matrices
fprintf('Size of Ground Truths: %d rows, %d columns\n', size(groundTruths, 1), size(groundTruths, 2));
fprintf('Size of Innovation Sequence: %d rows, %d columns\n', size(innovationSequence, 1), size(innovationSequence, 2));
fprintf('Size of Prediction Errors: %d rows, %d columns\n', size(predictionErrors, 1), size(predictionErrors, 2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Number of time steps
num_timesteps = size(groundTruths, 1);

% Flatten the matrices into vectors for easier processing
groundTruths_flat = groundTruths(:);
predictionErrors_flat = predictionErrors(:);

% Define the number of bins for the heatmap
num_bins = 100;

% Create a 2D histogram (heatmap) of ground truths vs. prediction errors
[x_edges, y_edges] = ndgrid(linspace(min(groundTruths_flat), max(groundTruths_flat), num_bins), ...
                            linspace(min(predictionErrors_flat), max(predictionErrors_flat), num_bins));

% Use histcounts2 to create a 2D histogram
counts = histcounts2(groundTruths_flat, predictionErrors_flat, ...
                     linspace(min(groundTruths_flat), max(groundTruths_flat), num_bins), ...
                     linspace(min(predictionErrors_flat), max(predictionErrors_flat), num_bins));

% Plot the heatmap
figure;
h = imagesc(x_edges(:,1), y_edges(1,:), counts');
set(gca, 'YDir', 'normal'); 

% Set the colormap to white initially, then apply your preferred colormap
colormap([1 1 1; jet]); % The first color is white

% Set the color of NaNs or zero counts to white
set(h, 'AlphaData', counts' > 0);

% Add colorbar and labels
colorbar;
xlabel('Ground Truth');
ylabel('Prediction Error');
title('Heatmap of Prediction Errors vs. Ground Truth');

% Save the heatmap as an image
saveas(gcf, fullfile(dataDir, 'GroundTruth_vs_PredictionError_Heatmap.png'));


% plot the relationship between ground truth values and prediction errors
figure;
scatter(groundTruths(:), predictionErrors(:), 'filled');
xlabel('Ground Truths');
ylabel('Prediction Errors');
title('Scatter Plot of Ground Truths vs. Prediction Errors');
grid on;

% Save the scatter plot as an image
saveas(gcf, fullfile(dataDir, 'GroundTruth_vs_PredictionError_Scatter.png'));

