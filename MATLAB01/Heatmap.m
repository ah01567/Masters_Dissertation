
% Number of Monte Carlo runs
num_runs = 100;

% Define system matrices
A = eye(2); % Identity matrix for simplicity
H = eye(2); % Identity matrix for simplicity

% Initial state estimate and covariance
x_hat_0 = [0; 0]; % Initial state estimate
P_0 = eye(2); % Initial state covariance

% Range of Q_sim and R_sim values to test
Q_sim_values = linspace(0.01, 1, 100); % Values from 0.01 to 1 with 0.01 step
R_sim_values = linspace(0.01, 1, 100); % Values from 0.01 to 1 with 0.01 step

% Process noise covariance (Q) for Kalman filter (constant)
Q = 0.1 * eye(2); % Process noise covariance
R = 0.1 * eye(2); % Measurement noise covariance

% Time vector (Define the length of the simulation)
T = 0:0.1:10; % time vector

% Initialize matrix to store mean NEES for each combination of Q_sim and R_sim values
mean_NEES_matrix = zeros(length(Q_sim_values), length(R_sim_values));

% Initialize waitbar
h = waitbar(0, 'Initializing...');

total_iterations = length(Q_sim_values) * length(R_sim_values);
current_iteration = 0;

for q_index = 1:length(Q_sim_values)
    for r_index = 1:length(R_sim_values)
        Q_sim = Q_sim_values(q_index) * eye(2);
        R_sim = R_sim_values(r_index) * eye(2);
        
        % Initialize arrays to store NEES values for all runs
        NEES_values = zeros(num_runs, length(T));
        
        for run = 1:num_runs
            % Generate Simulated Data
            x_true = zeros(2, length(T)); % True state
            z = zeros(2, length(T)); % Measurements
            for i = 1:length(T)
                % Simulate true state dynamics 
                if i == 1
                    x_true(:, i) = x_hat_0 + sqrtm(Q_sim) * randn(2, 1);
                else
                    x_true(:, i) = A * x_true(:, i-1) + sqrtm(Q_sim) * randn(2, 1);
                end
                % Simulate measurements (true state + noise)
                z(:, i) = H * x_true(:, i) + sqrtm(R_sim) * randn(2, 1);
            end

            % Run the Kalman Filter
            x_hat = zeros(2, length(T)); % Estimated states
            P = zeros(2, 2, length(T)); % State covariances

            % Initialize Kalman filter with initial state estimate and covariance
            x_hat(:, 1) = x_hat_0;
            P(:, :, 1) = P_0;

            % Loop over time steps
            for i = 2:length(T)
                % Prediction step
                x_hat(:, i) = A * x_hat(:, i-1); % Predicted state
                P(:, :, i) = A * P(:, :, i-1) * A' + Q; % Predicted covariance

                % Update step
                K = P(:, :, i) * H' / (H * P(:, :, i) * H' + R); % Kalman gain
                x_hat(:, i) = x_hat(:, i) + K * (z(:, i) - H * x_hat(:, i)); % Updated state estimate
                P(:, :, i) = (eye(2) - K * H) * P(:, :, i); % Updated covariance

                % Calculate NEES
                e = x_hat(:, i) - x_true(:, i); % Estimation error
                NEES_values(run, i) = e' * (P(:, :, i) \ e); % NEES 
            end
        end

        % Calculate mean NEES over all runs and time steps for the current combination of Q_sim and R_sim values
        mean_NEES_matrix(q_index, r_index) = mean(mean(NEES_values, 2)); % Mean NEES over all runs and time steps

        % Update waitbar
        current_iteration = current_iteration + 1;
        waitbar(current_iteration / total_iterations, h, ...
            sprintf('Processing Q_sim value %d of %d and R_sim value %d of %d', ...
            q_index, length(Q_sim_values), r_index, length(R_sim_values)));
    end
end

% Close waitbar
close(h);

% Generate a color map for the mean NEES values
figure;
contourf(R_sim_values, Q_sim_values, mean_NEES_matrix);
colorbar;
xlabel('R_{sim} values');
ylabel('Q_{sim} values');
title('Mean NEES for different combinations of Q_{sim} and R_{sim}');
