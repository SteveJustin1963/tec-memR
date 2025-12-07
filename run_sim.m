% ============================================================
% Memristor Simulation Runner Script
% ============================================================

% Add current directory to path to access SIMULATE_MEMRISTOR function
addpath(pwd);

% --- Generate an input waveform ---
dt = 1e-6;                 % time step
t_end = 0.02;              % 20 ms
t = 0:dt:t_end;            % time vector

f = 50;                    % 50 Hz sine
Vamp = 1.0;                % 1 V amplitude
InputVoltageArray = Vamp * sin(2*pi*f*t);

% --- Optional parameter overrides ---
params = struct();
params.R_ON  = 100;
params.R_OFF = 10000;
params.D     = 10e-9;
params.MU_V  = 1e-10;
params.w0    = 0.5 * params.D;

% --- Run simulation ---
res = SIMULATE_MEMRISTOR(InputVoltageArray, dt, params);

% --- Persistent I-V hysteresis graph ---
figure(1);
clf;
plot(res.V, res.I, "LineWidth", 1);
grid on;
xlabel("Voltage (V)");
ylabel("Current (A)");
title("Memristor I-V Hysteresis (Linear Drift Model)");

% Display some results
fprintf('\nSimulation completed!\n');
fprintf('Number of points: %d\n', length(res.time));
fprintf('Time range: %.4f to %.4f seconds\n', min(res.time), max(res.time));
fprintf('Voltage range: %.4f to %.4f V\n', min(res.V), max(res.V));
fprintf('Current range: %.6e to %.6e A\n', min(res.I), max(res.I));
fprintf('Resistance range: %.2f to %.2f Ohms\n', min(res.R), max(res.R));
fprintf('Internal state (w) range: %.4e to %.4e m\n', min(res.w), max(res.w));

% Keep the plot window alive in many CLI workflows
drawnow;
disp("Plot ready. Press Ctrl+C or close the figure window to exit.");
pause;
