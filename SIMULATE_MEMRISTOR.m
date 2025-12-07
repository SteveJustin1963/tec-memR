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
