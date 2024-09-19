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
% Loop over each component 
for i = 1:size(innovationSequence, 2)
    % Flatten the matrices into vectors for the i-th component
    innovation_flat = innovationSequence(:, i);
    predictionErrors_flat = predictionErrors(:, i);
    
    % Scatter Plot of Innovation vs. Prediction Error (i-th Component)
    figure;
    scatter(innovation_flat, predictionErrors_flat, 'filled');
    xlabel(sprintf('Innovation Sequence (Component %d)', i));
    ylabel(sprintf('Prediction Error (Component %d)', i));
    title(sprintf('Scatter Plot of Innovation vs. Prediction Error (Component %d)', i));
    grid on;
    
    % Save the scatter plot as an image
    saveas(gcf, fullfile(dataDir, sprintf('Innovation_vs_PredictionError_Scatter_Component%d.png', i)));
    
    % Define the number of bins for the heatmap
    num_bins = 300;

    % Create a 2D histogram (heatmap) of innovation vs. prediction errors
    [x_edges, y_edges] = ndgrid(linspace(min(innovation_flat), max(innovation_flat), num_bins), ...
                                linspace(min(predictionErrors_flat), max(predictionErrors_flat), num_bins));

    % Use histcounts2 to create a 2D histogram
    counts = histcounts2(innovation_flat, predictionErrors_flat, ...
                         linspace(min(innovation_flat), max(innovation_flat), num_bins), ...
                         linspace(min(predictionErrors_flat), max(predictionErrors_flat), num_bins));

    % Plot the heatmap of Innovation vs. Prediction Error (i-th Component)
    figure;
    h = imagesc(x_edges(:,1), y_edges(1,:), counts');
    set(gca, 'YDir', 'normal'); % Ensure the y-axis is not flipped
    colormap([1 1 1; jet]);  % Setting the 0 values first color to whit, then jet
    colorbar;
    xlabel(sprintf('Innovation Sequence (Component %d)', i));
    ylabel(sprintf('Prediction Error (Component %d)', i));
    title(sprintf('Heatmap of Innovation vs. Prediction Error (Component %d)', i));

    % Set the color of NaNs to white
    set(h, 'AlphaData', ~isnan(counts') & counts' > 0); % Color only non-zero counts

    % Save the heatmap as an image
    saveas(gcf, fullfile(dataDir, sprintf('Innovation_vs_PredictionError_Heatmap_Component%d.png', i)));
end