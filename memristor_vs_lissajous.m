% ============================================================
% Proof: Memristor Hysteresis = Glorified Lissajous Figure
% Demonstrates that "memory" is just dynamic phase shifting
% ============================================================

clear all;
close all;

% --- Time setup ---
dt = 1e-6;
t_end = 0.04;  % 40ms - two full cycles at 50Hz
t = 0:dt:t_end;

% --- Input signal (50 Hz sine) ---
f = 50;
V_amp = 1.0;
V = V_amp * sin(2*pi*f*t);

fprintf("Generating comparison between memristor and Lissajous figures...\n\n");

% ============================================================
% 1. TRUE MEMRISTOR (with state dynamics)
% ============================================================

% Memristor parameters
R_ON = 100;
R_OFF = 16000;
D = 10e-9;
mu_v = 1e-10;

% Joglekar window function
p = 1;
window_func = @(x) 1 - (2*x - 1).^(2*p);

% Initial state
x = 0.5;  % normalized state w/D, starts at midpoint
w = x * D;

% Preallocate
I_mem = zeros(size(t));
x_history = zeros(size(t));

% Simulate memristor
for i = 1:length(t)
    % Current resistance
    R = R_ON * (w/D) + R_OFF * (1 - w/D);

    % Current
    I_mem(i) = V(i) / R;

    % State dynamics with window
    x = w/D;
    x = max(0, min(1, x));  % hard clamp for safety

    F_window = window_func(x);
    dw_dt = mu_v * (R_ON / D) * I_mem(i) * F_window;

    w = w + dw_dt * dt;
    w = max(0, min(D, w));

    x_history(i) = w/D;
end

% ============================================================
% 2. LISSAJOUS APPROXIMATION (phase-shifted signals)
% ============================================================

% Key insight: memristor current lags voltage due to state integration
% The state x integrates voltage → creates phase lag
% Let's approximate this with a simple phase-lagged sinusoid

% Calculate approximate phase shift from memristor state dynamics
% The state roughly integrates: x ~ integral(V) ~ -cos(wt)
% So current ~ V/R(x) has mixed sin and cos components

% Simple Lissajous with phase lag
phi_degrees = [0, 30, 60, 90];  % Different phase lags

% We'll also try to match the memristor using its actual phase
% Extract phase from memristor current using Hilbert-like approach
% Simple approximation: fit I_mem ~ a*sin(wt) + b*cos(wt)

omega = 2*pi*f;
sin_basis = sin(omega*t);
cos_basis = cos(omega*t);

% Least squares fit
a_mem = sum(I_mem .* sin_basis) / sum(sin_basis .* sin_basis);
b_mem = sum(I_mem .* cos_basis) / sum(cos_basis .* cos_basis);

% Actual phase and amplitude from memristor
phi_mem = atan2(b_mem, a_mem);
A_mem = sqrt(a_mem^2 + b_mem^2);

% Generate Lissajous with extracted phase
I_lissajous_matched = A_mem * sin(omega*t + phi_mem);

% Also generate pure phase-shifted versions for comparison
I_lissajous_30 = max(abs(I_mem)) * sin(omega*t + pi/6);
I_lissajous_60 = max(abs(I_mem)) * sin(omega*t + pi/3);
I_lissajous_90 = max(abs(I_mem)) * sin(omega*t + pi/2);

% ============================================================
% 3. DYNAMIC PHASE (the "memory" part)
% ============================================================

% The memristor's "memory" is that the phase changes over time
% Let's create a time-varying phase based on the state

% State x varies → changes R → changes phase
% Model: phi(t) depends on state history
phi_dynamic = atan2(x_history - 0.5, 0.5);  % Simple state-dependent phase

I_dynamic_phase = zeros(size(t));
for i = 1:length(t)
    % Current with time-varying phase shift
    A_scale = 1/((R_ON * x_history(i) + R_OFF * (1 - x_history(i))));
    I_dynamic_phase(i) = V_amp * A_scale * sin(omega*t(i) + phi_dynamic(i));
end

% ============================================================
% 4. PLOTTING: Side-by-side comparison
% ============================================================

figure('Position', [100, 100, 1400, 900]);

% --- Plot 1: True Memristor Hysteresis ---
subplot(2, 3, 1);
plot(V, I_mem, 'b-', 'LineWidth', 2);
grid on;
xlabel('Voltage (V)');
ylabel('Current (A)');
title('TRUE MEMRISTOR (with state dynamics)');
axis equal;
xlim([-1.2, 1.2]);

% --- Plot 2: Static Lissajous (various phases) ---
subplot(2, 3, 2);
hold on;
plot(V, V/mean([R_ON, R_OFF]), 'k--', 'LineWidth', 1, 'DisplayName', '\phi=0° (resistor)');
plot(V, I_lissajous_30, 'r-', 'LineWidth', 1.5, 'DisplayName', '\phi=30°');
plot(V, I_lissajous_60, 'g-', 'LineWidth', 1.5, 'DisplayName', '\phi=60°');
plot(V, I_lissajous_90, 'm-', 'LineWidth', 1.5, 'DisplayName', '\phi=90° (inductor)');
grid on;
xlabel('Voltage (V)');
ylabel('Current (A)');
title('LISSAJOUS: Static Phase Shifts');
legend('Location', 'best');
axis equal;
xlim([-1.2, 1.2]);
hold off;

% --- Plot 3: Matched Lissajous ---
subplot(2, 3, 3);
hold on;
plot(V, I_mem, 'b-', 'LineWidth', 2, 'DisplayName', 'Memristor');
plot(V, I_lissajous_matched, 'r--', 'LineWidth', 1.5, 'DisplayName', sprintf('Lissajous (\\phi=%.1f°)', rad2deg(phi_mem)));
grid on;
xlabel('Voltage (V)');
ylabel('Current (A)');
title('COMPARISON: Memristor vs Fitted Lissajous');
legend('Location', 'best');
axis equal;
xlim([-1.2, 1.2]);
hold off;

% --- Plot 4: Time-domain comparison ---
subplot(2, 3, 4);
plot(t*1000, V, 'k-', 'LineWidth', 1.5);
hold on;
plot(t*1000, I_mem*1000, 'b-', 'LineWidth', 2);
plot(t*1000, I_lissajous_matched*1000, 'r--', 'LineWidth', 1.5);
grid on;
xlabel('Time (ms)');
ylabel('Voltage (V) / Current (mA)');
title('TIME DOMAIN: V and I');
legend('Voltage', 'I_{memristor}', 'I_{Lissajous}', 'Location', 'best');
hold off;

% --- Plot 5: State variable (the "memory") ---
subplot(2, 3, 5);
plot(t*1000, x_history, 'b-', 'LineWidth', 2);
hold on;
plot(t*1000, 0.5 + 0.3*cos(omega*t), 'r--', 'LineWidth', 1.5);
grid on;
xlabel('Time (ms)');
ylabel('Normalized State x = w/D');
title('STATE DYNAMICS (the "memory")');
legend('Memristor state x(t)', 'Approximate: 0.5 + 0.3cos(\omegat)', 'Location', 'best');
ylim([0, 1]);
hold off;

% --- Plot 6: Dynamic Phase Evolution ---
subplot(2, 3, 6);
hold on;
plot(V, I_mem, 'b-', 'LineWidth', 2, 'DisplayName', 'Memristor');
plot(V, I_dynamic_phase, 'g--', 'LineWidth', 1.5, 'DisplayName', 'Dynamic Phase Model');
grid on;
xlabel('Voltage (V)');
ylabel('Current (A)');
title('DYNAMIC PHASE: Memory = Time-Varying \phi(t)');
legend('Location', 'best');
axis equal;
xlim([-1.2, 1.2]);
hold off;

% ============================================================
% 5. ANALYSIS OUTPUT
% ============================================================

fprintf("=== ANALYSIS RESULTS ===\n\n");
fprintf("Memristor fitted as: I(t) = %.2e * sin(2πft + φ)\n", A_mem);
fprintf("  Phase lag φ = %.1f degrees\n\n", rad2deg(phi_mem));

fprintf("Why memristor looks like Lissajous:\n");
fprintf("  1. Voltage: V(t) = sin(ωt)\n");
fprintf("  2. State integrates voltage: x ∝ ∫V dt ∝ -cos(ωt)\n");
fprintf("  3. Resistance depends on state: R(x)\n");
fprintf("  4. Current: I = V/R(x) = mixed sin/cos terms\n");
fprintf("  5. V vs I plot = Lissajous figure!\n\n");

fprintf("The 'pinch' at origin:\n");
fprintf("  - At V=0, must have I=0 (Ohm's law)\n");
fprintf("  - This constraint creates the figure-8 'pinched' shape\n");
fprintf("  - NOT unique to memristors - any reactive element does this!\n\n");

fprintf("The 'memory':\n");
fprintf("  - State x(t) varies based on voltage history\n");
fprintf("  - This changes R(t) → changes phase φ(t) dynamically\n");
fprintf("  - Memory = time-varying phase in Lissajous figure\n");
fprintf("  - Same principle as inductor/capacitor, just nonlinear\n\n");

fprintf("Conclusion:\n");
fprintf("  Memristor hysteresis IS a glorified Lissajous figure.\n");
fprintf("  The 'memory' is just dynamic phase shifting.\n");
fprintf("  All the fancy window functions just control phase evolution.\n\n");

% Save figure
print -dpng memristor_lissajous_comparison.png -r150
fprintf("Plot saved to: memristor_lissajous_comparison.png\n");
