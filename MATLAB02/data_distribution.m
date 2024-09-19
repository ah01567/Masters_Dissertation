% Define the path to the directory where the .txt files are stored
dataDir = '/Users/ahmedhenine/Desktop/'; 

% Define file name
trainingDataFile = fullfile(dataDir, 'training_data.txt');

% Read the data from the text file
trainingData = readmatrix(trainingDataFile);

% Flatten the matrix into a vector for easier processing
trainingData_flat = trainingData(:);

% Define the number of bins for the histogram 
num_bins = 50;

% Create a histogram of the training data
figure;
histogram(trainingData_flat, num_bins);

% Set the title and labels
title('Distribution of Training Data Values');
xlabel('Value');
ylabel('Frequency');

% Display the plot
grid on;

% Save the plot as an image
saveas(gcf, fullfile(dataDir, 'TrainingData_Distribution.png'));
