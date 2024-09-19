% Define the path to the directory where my .txt files are stored
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
% Flatten the matrices into vectors 
groundTruths_flat = groundTruths(:, 1);  % X position
innovation_flat = innovationSequence(:, 1);  % Innovation in X
predictionErrors_flat = predictionErrors(:, 1); % Error in X

% Flatten the matrices into vectors for Component 02
groundTruths_flat = groundTruths(:, 2);  % Y position
innovation_flat = innovationSequence(:, 2);  % Innovation in Y
predictionErrors_flat = predictionErrors(:, 2);  % Error in Y

% Create a 3D scatter plot
figure;
scatter3(groundTruths_flat, innovation_flat, predictionErrors_flat, 36, predictionErrors_flat, 'filled');
xlabel('Ground Truth (Pos X)');
ylabel('Innovation Sequence (Pos X)');
zlabel('Prediction Error (Pos X)');
title('3D Scatter Plot of Ground Truth, Innovation, and Prediction Error (Pos X)');
colorbar; 
grid on;

% Save the 3D scatter plot as an image
saveas(gcf, fullfile(dataDir, '3DScatter_component01.png'));

% Create a 3D scatter plot for Component 02
figure;
scatter3(groundTruths_flat, innovation_flat, predictionErrors_flat, 36, predictionErrors_flat, 'filled');
xlabel('Ground Truth (Pos Y)');
ylabel('Innovation Sequence (Pos Y)');
zlabel('Prediction Error (Pos Y)');
title('3D Scatter Plot of Ground Truth, Innovation, and Prediction Error (Pos Y)');
colorbar; 
grid on;

% Save the 3D scatter plot as an image
saveas(gcf, fullfile(dataDir, '3DScatter_Component02.png'));
