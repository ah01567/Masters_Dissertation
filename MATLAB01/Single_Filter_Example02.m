% Define system matrices
A = eye(2); 
H = eye(2); 

% Initial state estimate and covariance
x_hat_0 = [0; 0]; % Initial state estimate
P_0 = eye(2); % Initial state covariance

% Process noise covariance (Q) for Kalman filter (constant)
Q = 0.1 * eye(2); % Process noise covariance
R = 0.1 * eye(2); % Measurement noise covariance

% Time vector 
T = 0:0.1:10; 

% Range for Q_sim and R_sim
Q_sim_range = 0.01:0.01:1;
R_sim_range = 0.01:0.01:1;

% Initialize arrays for storing MEAN NEES and NIS values
mean_NEES = zeros(length(Q_sim_range), length(R_sim_range));
mean_NIS = zeros(length(Q_sim_range), length(R_sim_range));

% Loop over Q_sim and R_sim values
for q_idx = 1:length(Q_sim_range)
    for r_idx = 1:length(R_sim_range)
        Q_sim_value = Q_sim_range(q_idx);
        R_sim_value = R_sim_range(r_idx);

        % Generate simulated data
        Q_sim = Q_sim_value * eye(2);
        R_sim = R_sim_value * eye(2);

        % Initialize arrays for true state and measurements
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
        NEES_values = zeros(1, length(T)); % NEES values
        NIS_values = zeros(1, length(T)); % NIS values

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
            NEES_values(i) = e' * (P(:, :, i) \ e); % NEES

            % Calculate NIS
            v = z(:, i) - H * x_hat(:, i); % Innovation
            S = H * P(:, :, i) * H' + R_sim; % Innovation covariance
            NIS_values(i) = v' / S * v; % NIS
        end

        % Store mean NEES and NIS values
        mean_NEES(q_idx, r_idx) = mean(NEES_values);
        mean_NIS(q_idx, r_idx) = mean(NIS_values);
    end
end

% Plot MEAN NEES
figure;
hold on;
for r_idx = 1:length(R_sim_range)
    plot(Q_sim_range, mean_NEES(:, r_idx)); 
end
hold off;
xlabel('Q_{sim}');
ylabel('Mean NEES');
title('Mean NEES vs Q_{sim}');
grid on;
saveas(gcf, fullfile('/Users/ahmedhenine/Desktop/', sprintf('Mean NEES vs Q_{sim}.png', i)));

% Plot MEAN NIS
figure;
hold on;
for r_idx = 1:length(R_sim_range)
    plot(Q_sim_range, mean_NIS(:, r_idx)); 
end
hold off;
xlabel('Q_{sim}');
ylabel('Mean NIS');
title('Mean NIS vs Q_{sim}');
grid on;
saveas(gcf, fullfile('/Users/ahmedhenine/Desktop/', sprintf('Mean NIS vs Q_{sim}.png', i)));

% Plot Log(NEES)/2
figure;
hold on;
for r_idx = 1:length(R_sim_range)
    plot(Q_sim_range, log(mean_NEES(:, r_idx)/ 2)); 
end
hold off;
xlabel('Q_{sim}');
ylabel('Log(NEES)/2');
title('Log(NEES)/2 vs Q_{sim}');
grid on;
saveas(gcf, fullfile('/Users/ahmedhenine/Desktop/', sprintf('Log(NEES)2 vs Q_{sim}.png', i)));
