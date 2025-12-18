% ============================================================
% Memristor Lissajous Figure Transfer Function Derivation
% ============================================================
% This script demonstrates how memristors produce Lissajous figures
% and derives the transfer function H(ω) = I(ω)/V(ω)
%
% KEY INSIGHT: At AC frequencies (ω >> ω₀), a memristor behaves as
% a complex impedance Z(ω), creating a phase shift between V and I.
% Plotting I vs V produces Lissajous figures (pinched hysteresis loop).
% ============================================================

clear all;
close all;

fprintf('=== MEMRISTOR LISSAJOUS TRANSFER FUNCTION DERIVATION ===\n\n');

% ============================================================
% PART 1: THEORETICAL TRANSFER FUNCTION
% ============================================================
fprintf('PART 1: Transfer Function H(ω) = I(ω)/V(ω)\n');
fprintf('--------------------------------------------------\n\n');

% Memristor parameters
R_ON = 100;      % Ohms (high conductance state)
R_OFF = 10000;   % Ohms (low conductance state)
D = 10e-9;       % Device thickness (m)
MU_V = 1e-10;    % Ion mobility
w_initial = 0.5 * D;  % Initial state (50% doped)

% Calculate average resistance at this state
R_avg = R_ON * (w_initial/D) + R_OFF * (1 - w_initial/D);

fprintf('Memristor Parameters:\n');
fprintf('  R_ON  = %d Ω\n', R_ON);
fprintf('  R_OFF = %d Ω\n', R_OFF);
fprintf('  R_avg = %.1f Ω (at w = 0.5D)\n', R_avg);
fprintf('  Device thickness D = %.2e m\n', D);
fprintf('  Ion mobility μ_v = %.2e\n\n', MU_V);

% Derive characteristic frequency ω₀
% At ω₀, the memristor state change rate equals the signal frequency
omega_0 = 1 / (MU_V * R_ON * D);  % Characteristic frequency (rad/s)
f_0 = omega_0 / (2*pi);  % Hz

fprintf('Characteristic Frequency:\n');
fprintf('  ω₀ = %.2f rad/s\n', omega_0);
fprintf('  f₀ = %.2f Hz\n\n', f_0);

fprintf('Operating Regimes:\n');
fprintf('  ω << ω₀ (f << %.1f Hz): DC switching mode, state changes\n', f_0);
fprintf('  ω ≈ ω₀  (f ≈ %.1f Hz): Transition, unstable!\n', f_0);
fprintf('  ω >> ω₀ (f >> %.1f Hz): AC inference mode, passive impedance\n\n', f_0);

% ============================================================
% PART 2: DERIVE COMPLEX IMPEDANCE Z(ω)
% ============================================================
fprintf('PART 2: Complex Impedance Derivation\n');
fprintf('--------------------------------------------------\n\n');

% For AC operation, memristor acts as complex impedance:
% Z(ω) = R + jX
%
% Where:
%   R = resistance component (from current state w)
%   X = reactance (from state dynamics)
%
% The reactance comes from the finite response time of ion migration:
%   X(ω) ≈ R * (ω/ω₀) for ω << ω₀  (state tries to follow signal)
%   X(ω) ≈ 0           for ω >> ω₀  (state cannot follow, acts resistive)

freq_range = logspace(0, 6, 1000);  % 1 Hz to 1 MHz
omega_range = 2*pi*freq_range;

% Calculate impedance components
R_component = R_avg * ones(size(omega_range));  % Resistive part (constant)
X_component = R_avg * (omega_range / omega_0);  % Reactive part (frequency-dependent)

% Total impedance magnitude
Z_mag = sqrt(R_component.^2 + X_component.^2);

% Phase shift (THIS IS THE KEY FOR LISSAJOUS FIGURES!)
phase_shift = atan(X_component ./ R_component);  % radians
phase_shift_deg = phase_shift * 180/pi;

% Transfer function H(ω) = 1/Z(ω)
H_mag = 1 ./ Z_mag;  % Admittance (Siemens)

fprintf('Transfer Function:\n');
fprintf('  H(jω) = I(jω)/V(jω) = 1/Z(jω)\n');
fprintf('  Z(jω) = R + jX(ω)\n');
fprintf('  |H(jω)| = 1/|Z(jω)|\n');
fprintf('  ∠H(jω) = -atan(X/R)\n\n');

% ============================================================
% PART 3: LISSAJOUS FIGURE GENERATION
% ============================================================
fprintf('PART 3: Generating Lissajous Figures\n');
fprintf('--------------------------------------------------\n\n');

% Apply sinusoidal input voltage: V(t) = V₀·sin(ωt)
V0 = 1.0;  % 1V amplitude
t = linspace(0, 4*pi, 1000);  % Two complete cycles

% Test at three different frequencies
test_frequencies = [f_0/100, f_0, f_0*100];  % Below, at, and above ω₀
test_labels = {'Low (DC-like)', 'Transition', 'High (AC-like)'};

fprintf('Generating Lissajous figures at 3 frequencies:\n');
for i = 1:length(test_frequencies)
    f_test = test_frequencies(i);
    fprintf('  %d. f = %.2e Hz (%s)\n', i, f_test, test_labels{i});
end
fprintf('\n');

% ============================================================
% PART 4: PLOTTING
% ============================================================
figure('Position', [100, 100, 1400, 900]);

% Subplot 1: Impedance vs Frequency
subplot(2, 3, 1);
semilogx(freq_range, R_component, 'b-', 'LineWidth', 2, 'DisplayName', 'R (resistance)');
hold on;
semilogx(freq_range, X_component, 'r-', 'LineWidth', 2, 'DisplayName', 'X (reactance)');
semilogx(freq_range, Z_mag, 'k--', 'LineWidth', 2, 'DisplayName', '|Z| (magnitude)');
yl = ylim;
plot([f_0, f_0], yl, 'g--', 'LineWidth', 1.5, 'DisplayName', 'f₀ (characteristic)');
hold off;
grid on;
xlabel('Frequency (Hz)');
ylabel('Impedance (Ω)');
title('Memristor Impedance Components');
legend('Location', 'best');
set(gca, 'FontSize', 10);

% Subplot 2: Phase Shift vs Frequency
subplot(2, 3, 2);
semilogx(freq_range, phase_shift_deg, 'b-', 'LineWidth', 2);
hold on;
yl = ylim;
plot([f_0, f_0], yl, 'g--', 'LineWidth', 1.5, 'DisplayName', 'f₀');
hold off;
grid on;
xlabel('Frequency (Hz)');
ylabel('Phase Shift φ (degrees)');
title('Voltage-Current Phase Relationship');
legend('Location', 'best');
set(gca, 'FontSize', 10);

% Subplot 3: Transfer Function Magnitude
subplot(2, 3, 3);
loglog(freq_range, H_mag, 'b-', 'LineWidth', 2);
hold on;
yl = ylim;
plot([f_0, f_0], yl, 'g--', 'LineWidth', 1.5, 'DisplayName', 'f₀');
hold off;
grid on;
xlabel('Frequency (Hz)');
ylabel('|H(jω)| (Siemens)');
title('Transfer Function Magnitude');
legend('Location', 'best');
set(gca, 'FontSize', 10);

% Subplots 4-6: Lissajous Figures at Different Frequencies
for i = 1:length(test_frequencies)
    f_test = test_frequencies(i);
    omega_test = 2*pi*f_test;

    % Input voltage
    V_t = V0 * sin(omega_test * t);

    % Calculate phase shift at this frequency
    X_test = R_avg * (omega_test / omega_0);
    phi_test = atan(X_test / R_avg);

    % Current with phase shift: I(t) = (V₀/|Z|)·sin(ωt - φ)
    Z_test = sqrt(R_avg^2 + X_test^2);
    I_t = (V0 / Z_test) * sin(omega_test * t - phi_test);

    % Plot Lissajous figure (I vs V)
    subplot(2, 3, 3+i);
    plot(V_t, I_t, 'b-', 'LineWidth', 2);
    grid on;
    xlabel('Voltage V(t)');
    ylabel('Current I(t)');
    title(sprintf('%s\nf = %.2e Hz (f/f₀ = %.2e)\nφ = %.1f°', ...
                  test_labels{i}, f_test, f_test/f_0, phi_test*180/pi));
    axis equal;
    set(gca, 'FontSize', 10);

    % Add shape annotation
    if f_test < f_0
        text(0, max(I_t)*0.8, 'Wide hysteresis\n(DC switching)', ...
             'HorizontalAlignment', 'center', 'FontSize', 9, 'Color', 'r');
    elseif abs(f_test - f_0) < f_0*0.5
        text(0, max(I_t)*0.8, 'Transition region\n(Unstable!)', ...
             'HorizontalAlignment', 'center', 'FontSize', 9, 'Color', 'r');
    else
        text(0, max(I_t)*0.8, 'Ellipse → Circle\n(Phase computing)', ...
             'HorizontalAlignment', 'center', 'FontSize', 9, 'Color', 'r');
    end
end

% Overall title (using text instead of annotation for Octave compatibility)
% annotation not supported in --no-gui mode, skip it

% Save figure
print('memristor_transfer_function.png', '-dpng', '-r300');
fprintf('Figure saved: memristor_transfer_function.png\n\n');

% ============================================================
% PART 5: KEY FORMULAS SUMMARY
% ============================================================
fprintf('=== KEY FORMULAS FOR LISSAJOUS TRANSFER FUNCTION ===\n\n');

fprintf('1. Memristor Resistance (state-dependent):\n');
fprintf('   R(w) = R_ON·(w/D) + R_OFF·(1 - w/D)\n\n');

fprintf('2. Characteristic Frequency:\n');
fprintf('   ω₀ = 1/(μ_v·R_ON·D)\n');
fprintf('   f₀ = ω₀/(2π)\n\n');

fprintf('3. Complex Impedance (AC regime, ω >> ω₀):\n');
fprintf('   Z(jω) = R + jX(ω)\n');
fprintf('   X(ω) ≈ R·(ω/ω₀)  for ω < ω₀\n');
fprintf('   X(ω) ≈ 0          for ω >> ω₀\n\n');

fprintf('4. Phase Shift (creates Lissajous shape):\n');
fprintf('   φ(ω) = atan(X/R)\n\n');

fprintf('5. Transfer Function:\n');
fprintf('   H(jω) = I(jω)/V(jω) = 1/Z(jω)\n');
fprintf('   |H(jω)| = 1/√(R² + X²)\n');
fprintf('   ∠H(jω) = -φ(ω)\n\n');

fprintf('6. Time-Domain Signals:\n');
fprintf('   V(t) = V₀·sin(ωt)\n');
fprintf('   I(t) = (V₀/|Z|)·sin(ωt - φ)\n\n');

fprintf('7. Lissajous Figure Equation:\n');
fprintf('   Parametric: (V(t), I(t)) traces ellipse/circle\n');
fprintf('   Shape determined by phase φ:\n');
fprintf('     φ = 0°   → Line (resistor)\n');
fprintf('     φ = 45°  → Ellipse\n');
fprintf('     φ = 90°  → Circle (pure capacitor)\n');
fprintf('     φ varies → Hysteresis loop (memristor)\n\n');

fprintf('=== DONE ===\n');
fprintf('For neural networks: different memristor states → different φ → different interference patterns!\n');

% Explicitly close figures to prevent Qt cleanup crash
close all;
