% Define the path to the directory where the .txt files are stored
dataDir = '/Users/ahmedhenine/Desktop/';  

% Define file name
Q_file = fullfile(dataDir, 'Q.txt');

% Read the data from the text file
Q_data = readmatrix(Q_file);

% since Q matrices are 4x4 and each Q matrix occupies 4 consecutive rows
[num_rows, num_columns] = size(Q_data);
Q_matrices_count = num_rows / 4;

% Initialize arrays to store determinant and trace values
det_Q = zeros(Q_matrices_count, 1);
trace_Q = zeros(Q_matrices_count, 1);

% Loop through each 4x4 Q matrix
for i = 1:Q_matrices_count
    % Extract the 4x4 Q matrix from the corresponding rows
    Q_matrix = Q_data((i-1)*4+1:i*4, :);
    
    % Calculate the determinant and trace of the Q matrix
    det_Q(i) = det(Q_matrix);
    trace_Q(i) = trace(Q_matrix);
end

% Plot the determinant of Q
figure;
plot(det_Q, 'LineWidth', 1.5);
xlabel('Matrix Index');
ylabel('det(Q)');
title('Determinant of Q Matrices');
grid on;

% Save the plot as an image
saveas(gcf, fullfile(dataDir, 'Determinant_of_Q.png'));

% Plot the trace of Q
figure;
plot(trace_Q, 'LineWidth', 1.5);
xlabel('Matrix Index');
ylabel('trace(Q)');
title('Trace of Q Matrices');
grid on;

% Save the plot as an image
saveas(gcf, fullfile(dataDir, 'Trace_of_Q.png'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define file name
R_file = fullfile(dataDir, 'R.txt');

% Read the data from the text file
R_data = readmatrix(R_file);

% R matrices are 2x2 and each R matrix occupies 2 consecutive rows
[num_rows, num_columns] = size(R_data);
R_matrices_count = num_rows / 2;

% Initialize arrays to store determinant and trace values
det_R = zeros(R_matrices_count, 1);
trace_R = zeros(R_matrices_count, 1);

% Loop through each 2x2 R matrix
for i = 1:R_matrices_count
    % Extract the 2x2 R matrix from the corresponding rows
    R_matrix = R_data((i-1)*2+1:i*2, :);
    
    % Calculate the determinant and trace of the R matrix
    det_R(i) = det(R_matrix);
    trace_R(i) = trace(R_matrix);
end

% Plot the determinant of R
figure;
plot(det_R, 'LineWidth', 1.5);
xlabel('Matrix Index');
ylabel('det(R)');
title('Determinant of R Matrices');
grid on;

% Save the plot as an image
saveas(gcf, fullfile(dataDir, 'Determinant_of_R.png'));

% Plot the trace of R
figure;
plot(trace_R, 'LineWidth', 1.5);
xlabel('Matrix Index');
ylabel('trace(R)');
title('Trace of R Matrices');
grid on;

% Save the plot as an image
saveas(gcf, fullfile(dataDir, 'Trace_of_R.png'));