% Monte-Carlo 
% AIM: Adjusting Q_sim and see the OUTPUT in Mean NEES!!
% --------------------------------------------------

% Number of Monte Carlo runs
num_runs = 100;

% Define system matrices
A = eye(2); 
H = eye(2); 

% Initial state estimate and covariance
x_hat_0 = [0; 0]; % Initial state estimate
P_0 = eye(2); % Initial state covariance

% Measurement noise covariance (R)
R_sim = 0.1 * eye(2);

% Process noise covariance (Q) for Kalman filter
Q = 0.1 * eye(2); % Process noise covariance
R = 0.1 * eye(2); % Measurement noise covariance

% Time vector (Define the length of the simulation)
T = 0:0.1:10; 

% Range of Q_sim values to test
Q_sim_values = [0.01, 0.05, 0.1, 0.5, 1];

% Initialize array to store mean NEES for each Q_sim value
mean_NEES_all_Q_sim = zeros(length(Q_sim_values), 1);

for q_index = 1:length(Q_sim_values)
    Q_sim = Q_sim_values(q_index) * eye(2);
    
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
            NEES_values(run, i) = e' * (P(:, :, i) \ e); % NEES (corrected element-wise division)
        end
    end

    % Calculate mean NEES over all runs and time steps for the current Q_sim value
    mean_NEES_all_Q_sim(q_index) = mean(mean(NEES_values, 2)); % Mean NEES over all runs and time steps
end

% Plot the change of Mean NEES with different Q_sim values
figure;
plot(Q_sim_values, mean_NEES_all_Q_sim, 'o-');
xlabel('Q_{sim}');
ylabel('Mean NEES');
title('Mean NEES vs Q_{sim}');
grid on;
