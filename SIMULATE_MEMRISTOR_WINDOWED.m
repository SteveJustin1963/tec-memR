% ============================================================
% Memristor simulation with Joglekar window function (Octave)
% Produces proper pinched hysteresis loops
% ============================================================

function results = SIMULATE_MEMRISTOR_WINDOWED(InputVoltageArray, dt, params)
  % ---- Defaults ----
  R_ON_default  = 100;        % Ohms
  R_OFF_default = 16000;      % Ohms (increased for better contrast)
  D_default     = 10e-9;      % meters
  MU_V_default  = 10e-14;     % ion mobility (reduced for smoother behavior)
  w0_default    = 0.5 * D_default;
  t0_default    = 0;
  p_default     = 10;         % Window function parameter (higher = sharper boundaries)

  % ---- Input handling ----
  if nargin < 2
    error("SIMULATE_MEMRISTOR_WINDOWED requires InputVoltageArray and dt.");
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
  p     = getfield_with_default(params, "p",     p_default);

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
  x_arr = zeros(N,1);  % normalized state

  time = time0;

  % ---- Simulation Loop ----
  for k = 1:N
    voltage_in = Vin(k);

    % Calculate normalized state x = w/D ∈ [0,1]
    x = w / D;

    % Joglekar window function: f(x) = 1 - (2x - 1)^(2p)
    % This smoothly goes to 0 at boundaries, preventing hard saturation
    f_window = 1 - (2*x - 1)^(2*p);

    % Alternative: Biolek window (direction-dependent)
    % Uncomment to try:
    % if voltage_in >= 0
    %   f_window = 1 - (x)^(2*p);
    % else
    %   f_window = 1 - (1-x)^(2*p);
    % end

    % Calculate Instantaneous Memristance (Resistance)
    % M(w) = R_ON * (w/D) + R_OFF * (1 - (w/D))
    resistance = R_ON * x + R_OFF * (1 - x);

    % Calculate Current (Ohm's Law: I = V / M)
    current = voltage_in / resistance;

    % Calculate Change in Internal State WITH WINDOW FUNCTION
    % dw/dt = MU_V * (R_ON / D) * I(t) * f(x)
    dw_dt = MU_V * (R_ON / D) * current * f_window;

    % Update Internal State (w)
    w_new = w + dw_dt * dt;

    % Soft boundary conditions (window handles most, but safety clamp)
    if w_new > D
      w = D;
    elseif w_new < 0
      w = 0;
    else
      w = w_new;
    end

    % Record data
    t_arr(k) = time;
    v_arr(k) = voltage_in;
    i_arr(k) = current;
    r_arr(k) = resistance;
    w_arr(k) = w;
    x_arr(k) = x;

    time = time + dt;
  end

  % ---- Pack results ----
  results = struct();
  results.time = t_arr;
  results.V    = v_arr;
  results.I    = i_arr;
  results.R    = r_arr;
  results.w    = w_arr;
  results.x    = x_arr;

  results.params = struct("R_ON",R_ON,"R_OFF",R_OFF,"D",D,"MU_V",MU_V, ...
                          "w0",getfield_with_default(params,"w0",w0_default), ...
                          "time0",time0, "dt", dt, "p", p);
end


% Helper: safe field getter
function val = getfield_with_default(s, fieldname, defaultval)
  if isstruct(s) && isfield(s, fieldname)
    val = s.(fieldname);
  else
    val = defaultval;
  end
end
