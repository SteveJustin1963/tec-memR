% ============================================================
% Memristor Simulation with Window Function - Runner Script
% Produces proper pinched hysteresis loop
% ============================================================

% Add current directory to path
addpath(pwd);

% --- Generate an input waveform ---
dt = 1e-6;                 % time step (1 microsecond)
t_end = 0.04;              % 40 ms (2 full cycles at 50Hz)
t = 0:dt:t_end;            % time vector

f = 50;                    % 50 Hz sine
Vamp = 1.0;                % 1 V amplitude
InputVoltageArray = Vamp * sin(2*pi*f*t);

% --- Parameters optimized for nice hysteresis ---
params = struct();
params.R_ON  = 100;        % Low resistance state
params.R_OFF = 16000;      % High resistance state (increased contrast)
params.D     = 10e-9;      % Device thickness (10 nm)
params.MU_V  = 10e-14;     % Ion mobility (reduced for smoother loops)
params.w0    = 0.5 * params.D;  % Start at middle state
params.p     = 10;         % Window function parameter (10 = good smoothness)

% --- Run windowed simulation ---
fprintf('Running memristor simulation with Joglekar window function...\n');
res = SIMULATE_MEMRISTOR_WINDOWED(InputVoltageArray, dt, params);

% --- Create figure with multiple plots ---
figure(1, 'visible', 'off');  % Create invisible figure for file saving
clf;

% Main I-V hysteresis plot
subplot(2,2,1);
plot(res.V, res.I*1000, "LineWidth", 2, 'Color', [0.2 0.4 0.8]);
grid on;
xlabel("Voltage (V)", 'FontSize', 12);
ylabel("Current (mA)", 'FontSize', 12);
title("Memristor I-V Hysteresis (Windowed Model)", 'FontSize', 14, 'FontWeight', 'bold');
axis tight;

% Voltage vs Time
subplot(2,2,2);
plot(res.time*1000, res.V, "LineWidth", 1.5, 'Color', [0.8 0.2 0.2]);
grid on;
xlabel("Time (ms)", 'FontSize', 12);
ylabel("Voltage (V)", 'FontSize', 12);
title("Input Voltage vs Time", 'FontSize', 12);
axis tight;

% Resistance vs Time
subplot(2,2,3);
plot(res.time*1000, res.R/1000, "LineWidth", 1.5, 'Color', [0.2 0.7 0.3]);
grid on;
xlabel("Time (ms)", 'FontSize', 12);
ylabel("Resistance (kΩ)", 'FontSize', 12);
title("Memristance vs Time", 'FontSize', 12);
axis tight;

% Normalized State vs Time
subplot(2,2,4);
plot(res.time*1000, res.x, "LineWidth", 1.5, 'Color', [0.7 0.2 0.7]);
grid on;
xlabel("Time (ms)", 'FontSize', 12);
ylabel("Normalized State x = w/D", 'FontSize', 12);
title("Internal State vs Time", 'FontSize', 12);
axis([0 max(res.time)*1000 0 1]);

% Save to file
output_file = 'memristor_hysteresis.png';
print('-dpng', '-r300', output_file);
fprintf('Plot saved to: %s\n\n', output_file);

% --- Display statistics ---
fprintf('════════════════════════════════════════════════════════\n');
fprintf('Simulation Results Summary\n');
fprintf('════════════════════════════════════════════════════════\n');
fprintf('Number of points: %d\n', length(res.time));
fprintf('Time range: %.4f to %.4f seconds\n', min(res.time), max(res.time));
fprintf('Voltage range: %.4f to %.4f V\n', min(res.V), max(res.V));
fprintf('Current range: %.6e to %.6e A\n', min(res.I), max(res.I));
fprintf('Resistance range: %.2f to %.2f Ohms (%.2f to %.2f kΩ)\n', ...
        min(res.R), max(res.R), min(res.R)/1000, max(res.R)/1000);
fprintf('Internal state (w) range: %.4e to %.4e m\n', min(res.w), max(res.w));
fprintf('Normalized state (x) range: %.4f to %.4f\n', min(res.x), max(res.x));
fprintf('════════════════════════════════════════════════════════\n');
fprintf('\nParameters used:\n');
fprintf('  R_ON  = %d Ω\n', params.R_ON);
fprintf('  R_OFF = %d Ω\n', params.R_OFF);
fprintf('  D     = %.2e m\n', params.D);
fprintf('  μv    = %.2e (mobility)\n', params.MU_V);
fprintf('  p     = %d (window parameter)\n', params.p);
fprintf('════════════════════════════════════════════════════════\n');

% Check if loop looks pinched (should cross near origin)
center_idx = find(abs(res.V) < 0.1);  % Near zero voltage
if ~isempty(center_idx)
  center_currents = res.I(center_idx);
  fprintf('\nHysteresis loop quality check:\n');
  fprintf('  Current spread at V≈0: %.6e A\n', max(center_currents) - min(center_currents));
  fprintf('  (Larger spread = better pinched loop)\n');
end

fprintf('\n✓ Simulation complete! Check %s for the plot.\n', output_file);
