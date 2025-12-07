% ============================================================
% Memristor linear-drift simulation (Octave)
% Based on your pseudocode, same update/order, no info dropped.
%
% Produces a persistent I-V hysteresis graph at the end.
% ============================================================

function results = SIMULATE_MEMRISTOR(InputVoltageArray, dt, params)
  % ---- Defaults ----
  R_ON_default  = 100;        % Ohms
  R_OFF_default = 10000;      % Ohms
  D_default     = 10e-9;      % meters
  MU_V_default  = 1e-10;      % ion mobility (model units as given)
  w0_default    = 0.5 * D_default;
  t0_default    = 0;

  % ---- Input handling ----
  if nargin < 2
    error("SIMULATE_MEMRISTOR requires InputVoltageArray and dt.");
  end
  if nargin < 3 || isempty(params)
    params = struct();
  end

  % Allow overrides via params struct
  R_ON  = getfield_with_default(params, "R_ON",  R_ON_default);
  R_OFF = getfield_with_default(params, "R_OFF", R_OFF_default);
  D     = getfield_with_default(params, "D",     D_default);
  MU_V  = getfield_with_default(params, "MU_V",  MU_V_default);
  w     = getfield_with_default(params, "w0",    w0_default);
  time0 = getfield_with_default(params, "time0", t0_default);

  % Basic validation
  if dt <= 0
    error("dt must be > 0.");
  end
  if D <= 0
    error("D must be > 0.");
  end
  if R_ON <= 0 || R_OFF <= 0
    error("R_ON and R_OFF must be > 0.");
  end

  Vin = InputVoltageArray(:);  % column vector
  N = numel(Vin);

  % ---- Preallocate outputs ----
  t_arr = zeros(N,1);
  v_arr = zeros(N,1);
  i_arr = zeros(N,1);
  r_arr = zeros(N,1);
  w_arr = zeros(N,1);

  time = time0;

  % ---- Simulation Loop ----
  for k = 1:N
    voltage_in = Vin(k);

    % 2a. Calculate Instantaneous Memristance (Resistance)
    % M(w) = R_ON * (w/D) + R_OFF * (1 - (w/D))
    resistance = R_ON * (w / D) + R_OFF * (1 - (w / D));

    % 2b. Calculate Current (Ohm's Law: I = V / M)
    current = voltage_in / resistance;

    % 2c. Calculate Change in Internal State (dw/dt)
    % dw/dt = MU_V * (R_ON / D) * I(t)
    dw_dt = MU_V * (R_ON / D) * current;

    % 2d. Update Internal State (w)
    w_new = w + dw_dt * dt;

    % 2e. Apply Boundary Conditions (w must be constrained)
    if w_new > D
      w = D;            % Fully conductive (R_ON)
    elseif w_new < 0
      w = 0;            % Fully non-conductive (R_OFF)
    else
      w = w_new;
    end

    % 2f. Record and Advance
    % (Matches pseudocode order: current/resistance computed before update,
    %  but recorded alongside updated w.)
    t_arr(k) = time;
    v_arr(k) = voltage_in;
    i_arr(k) = current;
    r_arr(k) = resistance;
    w_arr(k) = w;

    time = time + dt;
  end

  % ---- Pack results ----
  results = struct();
  results.time = t_arr;
  results.V    = v_arr;
  results.I    = i_arr;
  results.R    = r_arr;
  results.w    = w_arr;

  results.params = struct("R_ON",R_ON,"R_OFF",R_OFF,"D",D,"MU_V",MU_V, ...
                          "w0",getfield_with_default(params,"w0",w0_default), ...
                          "time0",time0, "dt", dt);
end


% Helper: safe field getter
function val = getfield_with_default(s, fieldname, defaultval)
  if isstruct(s) && isfield(s, fieldname)
    val = s.(fieldname);
  else
    val = defaultval;
  end
end


% ============================================================
% Example run (uncomment to use as a script section)
% ============================================================
%{
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

% Keep the plot window alive in many CLI workflows
drawnow;
disp("Plot ready. Close the figure window or press any key here to continue.");
pause;
%}
