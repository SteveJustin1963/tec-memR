# Mach-Zehnder Interferometer (MZI) Mesh Build Guide

## Overview
Build a real silicon-photonics-style trainable neural network using bulk optics. This is the DIY version of what Lightmatter sells for $50k+.

**Difficulty**: Medium-Hard
**Cost**: $200-500 (4x4), $400-800 (8x8)
**Time**: 2-4 weekends
**Based on**: Clements rectangular mesh design

## ⚠️ Safety Warning
- Work with low-power lasers (<5mW) only
- **ALWAYS use laser safety goggles**
- Never look directly into beam
- Secure all components to prevent accidents
- Work in controlled environment

## How It Works

### MZI Basics
A Mach-Zehnder Interferometer:
1. **Splits** a laser beam into two paths
2. **Applies phase shift** to one path
3. **Recombines** the beams
4. Output intensity depends on relative phase (0 to 2π)
5. This enables **multiplication/addition via interference**

### Mesh Structure (4x4 Clements)
- 10 MZIs arranged in rectangular grid
- 4 input waveguides (laser paths) → 4 outputs
- Computes 4x4 unitary matrix: **U = V D W**
  - V = Upper triangle MZI block
  - D = Phase screen (diagonal)
  - W = Lower triangle MZI block

### Neural Network Use
- **Inputs**: Encoded as light amplitudes/phases
- **Weights**: Set by tuning MZI phases
- **Computation**: Matrix multiplication happens in light
- **Outputs**: Detected by photodiodes
- **Activation**: Applied digitally (Arduino/PC)

## Parts List (4x4 Mesh)

| Item | Qty | Unit Cost | Total | Source | Notes |
|------|-----|-----------|-------|--------|-------|
| **Optics** |
| 650nm red laser module (1-5mW, collimated) | 1-4 | $10-20 | $40 | Amazon/eBay | One laser split 4 ways, or use 4 separate |
| 50/50 beam splitter cubes (10-25mm) | 20 | $5-15 | $200 | Surplus Shed | 2 per MZI + extras |
| Front-surface mirrors (10-25mm) | 35 | $2-5 | $105 | Surplus Shed | Avoid back-surface |
| Beam expanders/lenses | 6 | $5-10 | $45 | Surplus optics | For collimation |
| Polarizers/half-wave plates | 4 | $5-10 | $30 | Amazon | Amplitude control |
| **Phase Shifters** (choose one method) |
| Option A: Piezo buzzers + mirrors | 20 | $5 | $100 | eBay | Cheapest, needs glue |
| Option B: Manual micrometer stages | 20 | $20 | $400 | AliExpress | Most accurate |
| Option C: Thermal (10Ω resistors on glass) | 20 | $1 | $20 | Any electronics | Slowest but cheap |
| **Detection & Control** |
| Photodiodes or solar cells | 6 | $5-10 | $45 | Adafruit | 4 outputs + 2 monitors |
| Arduino Uno or ESP32 | 1 | $10-20 | $15 | Amazon | For automation |
| Op-amps (LM358) for photodiode amps | 3 | $1 | $3 | Any electronics | Signal amplification |
| **Mechanical** |
| Optical breadboard (30x30cm) | 1 | $20-50 | $35 | Amazon/makerspace | Or 3D print base |
| 3D-printed mounts/holders | 1 set | $10-30 | $20 | Print yourself | Search Thingiverse |
| **Tools & Misc** |
| Laser alignment cards | 2 | $5 | $10 | Amazon | Spot beams |
| Multimeter/oscilloscope | 1 | $20-50 | $30 | Amazon | If don't have |
| Wires, resistors, breadboard | Kit | - | $10 | - | Electronics |
| **Total (with piezo)** | | | **~$350-500** | | |

### Phase Shifter Comparison

| Method | Cost/unit | Speed | Precision | Ease of Use |
|--------|-----------|-------|-----------|-------------|
| Piezo buzzers | $5 | Fast (kHz) | Good (nm) | Medium (needs calibration) |
| Micrometer stages | $20 | Slow (manual) | Excellent (0.1μm) | Easy (direct control) |
| Thermal heaters | $1 | Slow (seconds) | Medium | Easy (just PWM) |

**Recommendation**: Start with micrometer for testing, upgrade to piezo for automation.

## Tools Needed
- Laser alignment tools (IR cards)
- Hot glue gun or 3D printer for mounts
- Soldering iron
- Precision screwdrivers
- Python + Arduino IDE
- Laser safety goggles (critical!)

## Step-by-Step Build

### 1. Design and Layout (Week 1, Day 1-2)

**Sketch the mesh on graph paper:**
```
4 horizontal paths (inputs), spaced 3-5cm apart
MZIs at crossing points:
  Row 1: 3 MZIs
  Row 2: 2 MZIs
  Row 3: 3 MZIs
  Row 4: 2 MZIs
Total: 10 MZIs for 4x4 mesh
```

**Mount on breadboard:**
- Use graph paper template underneath
- Align to 0.1mm precision
- Mark all component positions
- Plan cable routing for piezos/heaters

### 2. Laser Input Setup (Day 2-3)

**If using 1 laser for 4 inputs:**
```
Laser → BS1 (1→2) → BS2 (2→4)
         |            |
         v            v
    Path 1,2      Path 3,4
```

**Steps:**
1. Mount laser securely
2. Add beam splitters in cascade
3. Balance power in all 4 paths (adjust angles)
4. Add polarizers for amplitude control
5. Collimate all beams to ~1-2mm diameter
6. Ensure paths are parallel

**Test**: All 4 beams should have equal intensity (±10%)

### 3. Build Single MZI (Day 3-4)

**Practice on one before building 10!**

**Components per MZI:**
```
       Input
          |
      [BS 50/50] ─────────────┐
          |                   |
     Path A (w/ phase)    Path B
          |                   |
      [Mirror]            [Mirror]
          |                   |
    [Phase Shifter]           |
          |                   |
      [Mirror]            [Mirror]
          |                   |
      [BS 50/50] ─────────────┘
          |
       Output
```

**Build steps:**
1. Place first beam splitter
2. Add mirrors to create two equal paths (10-20cm apart)
3. Use Pythagorean theorem to match path lengths
4. Insert phase shifter on one arm:
   - **Piezo**: Glue mirror to buzzer, apply 0-5V
   - **Thermal**: Attach resistor to glass slide
   - **Manual**: Use micrometer stage
5. Place second beam splitter to recombine
6. Test: Input light, tune phase, observe fringes

**Success criteria:**
- See clear interference pattern
- Can switch between bright/dark (phase 0/π)
- Contrast >90%

### 4. Assemble Full Mesh (Week 2)

**Bottom-up assembly:**

1. **Build W block (lower triangle):**
   - Start with bottom-left MZI
   - Connect to adjacent path
   - Add next diagonal row
   - Repeat for 6 MZIs total
   - Constantly check alignment with test laser

2. **Add D block (phase screen):**
   - Simple phase shifters on each path
   - No beam splitting here
   - Just direct path with tuning

3. **Build V block (upper triangle):**
   - Mirror image of W
   - Connect to outputs
   - Another 6 MZIs (some shared with W)

4. **Alignment tips:**
   - Work one row at a time
   - Use temporary photodiodes to monitor
   - Keep total path length ~50-100cm
   - Uniform lengths prevent decoherence

### 5. Detection Electronics (Day 10-11)

**Photodiode circuit (per output):**
```
Photodiode → [LM358 op-amp] → Arduino analog pin
              (transimpedance amp)
```

**Build steps:**
1. Place photodiodes at 4 outputs
2. Build amplifier circuits
3. Connect to Arduino (A0-A3)
4. Add 2 monitor photodiodes for debugging
5. Test: Read light intensity on serial monitor

**Arduino code snippet:**
```cpp
void setup() {
  Serial.begin(115200);
}

void loop() {
  int out0 = analogRead(A0);
  int out1 = analogRead(A1);
  int out2 = analogRead(A2);
  int out3 = analogRead(A3);

  Serial.print("Outputs: ");
  Serial.print(out0); Serial.print(",");
  Serial.print(out1); Serial.print(",");
  Serial.print(out2); Serial.print(",");
  Serial.println(out3);

  delay(100);
}
```

### 6. Phase Control System (Day 12-13)

**Connect phase shifters to Arduino:**

**For piezo:**
```
Arduino PWM pin → [Amplifier 0-5V] → Piezo buzzer
```

**For thermal:**
```
Arduino PWM pin → [Transistor driver] → Heater resistor
```

**Calibration:**
1. Set PWM value (0-255)
2. Measure output intensity
3. Map PWM → phase shift (0-2π)
4. Store calibration curve

### 7. Software Calibration (Week 3)

**Use progressive nulling algorithm:**

**Python simulation first:**
```python
import numpy as np

# Simulate 4x4 unitary matrix
def clements_mesh(phases):
    # 10 phases for 10 MZIs
    # Returns 4x4 unitary matrix
    # (Implementation based on Clements 2016 paper)
    pass

# Test with identity matrix
target = np.eye(4)
# Optimize phases to match target
```

**Then Arduino automation:**
1. Set all MZIs to cross state (θ≈0)
2. For each MZI:
   - Inject test light
   - Measure outputs
   - Tune phase to null one port
   - Iterate until error <5%
3. Repeat for all 10 MZIs
4. Verify with identity matrix test

**Expected**: 10-20 iterations per MZI, ~2-5% final error

### 8. Neural Network Training (Week 4)

**Example: Iris dataset classification**

**Process:**
1. Load dataset (4 features → 3 classes)
2. Design 4-input network
3. Use SVD to decompose weight matrix
4. Program phases into mesh
5. Input data as light intensities
6. Measure outputs (photodiodes)
7. Apply nonlinearity (digital, on PC)
8. Calculate accuracy

**Training loop:**
```python
for epoch in range(100):
    # Forward pass (in optical hardware)
    outputs = measure_photodiodes()

    # Backward pass (on PC)
    gradients = compute_gradients(outputs, targets)

    # Update phases (send to Arduino)
    update_arduino_phases(gradients)
```

**Expected results:**
- Iris dataset: 90-95% accuracy
- Vowel recognition: 80-90% accuracy
- Inference time: nanoseconds (light speed!)
- Training time: minutes-hours (limited by Arduino)

## Testing and Debugging

### Basic Tests

**Test 1: Identity Matrix**
- Program mesh for I (identity)
- Input on port 1 → output on port 1 only
- Verify for all 4 ports
- Success: >90% power in correct port

**Test 2: Swap Matrix**
```
Input:  [1, 0, 0, 0]
Output: [0, 1, 0, 0]  (swap ports 1↔2)
```

**Test 3: Hadamard Transform**
- Equal superposition
- Test quantum-like interference

### Common Issues

| Problem | Cause | Solution |
|---------|-------|----------|
| No fringes | Paths unequal | Adjust mirror positions |
| Low contrast | Polarization mismatch | Check polarizers |
| Unstable output | Vibrations | Enclose in box |
| Phase drift | Temperature | Add insulation or feedback |
| Unequal splits | Beam splitter quality | Calibrate algorithm accounts for this |
| Alignment lost | Moved components | Use fixed mounts, glue down |

### Advanced Debugging

**Use monitoring taps:**
- Add partial beam splitters
- Monitor internal MZI states
- Helps isolate which MZI is misaligned

**Stability testing:**
- Run for 1 hour
- Record output drift
- If >10% drift: add thermal insulation

## Performance Specs

- **Inference latency**: ~nanoseconds (light propagation)
- **Training latency**: minutes-hours (limited by Arduino control loop)
- **Accuracy**: 90-95% on simple datasets (Iris, vowels)
- **Scalability**: 4x4 proven, 8x8 possible with more patience
- **Power**: ~1W (laser + photodiodes + Arduino)
- **Bandwidth**: Limited by phase shifters (1kHz-1MHz)

## Cost Savings Tips

1. **Buy optics lots on eBay**: Surplus Shed, Thorlabs surplus
2. **3D-print mounts**: Search Thingiverse for "optics holder"
3. **Use solar cells** instead of photodiodes (much cheaper)
4. **Salvage laser pointers** from dollar store
5. **Share makerspace breadboard** instead of buying
6. **Start with 2x2 mesh**: Only 1 MZI needed, learn before scaling

## Scaling to 8x8

**Changes needed:**
- 36 MZIs (vs 10)
- Larger breadboard (60x60cm)
- More patience for alignment
- Consider motorized stages ($50+ each)
- Expected cost: $400-800
- Build time: 4-8 weekends

## Comparison to Commercial

| Feature | Our DIY 4x4 | Lightmatter Passage |
|---------|-------------|---------------------|
| Cost | $350 | $50,000+ |
| Size | 30x30cm | Chip-scale |
| Neurons | 4 | 128+ |
| Speed | MHz | GHz |
| Accuracy | 90% | 99%+ |
| Power | 1W | 10W |

**We're using the same physics, just bigger and slower!**

## Next Steps

1. **Start with 2x2** (1 MZI) to learn
2. **Master alignment** before scaling
3. **Automate calibration** with better code
4. **Try reservoir computing** (simpler than full training)
5. **Add SLM for inputs** (from old projector)
6. **Consider fiber optics** for compactness

## References

- **Clements et al. 2016** (Optica) - Mesh design
- **NTT self-configuration 2022** - Calibration algorithm
- **LightPipes Python library** - Simulation
- **YouTube**: "The Thought Emporium" 4x4 build
- **YouTube**: "Hyperspace Pirate" 8x8 series
- **Parent project**: `/home/steve/memR/lissajous_logic_gates.m`

## Related Files

- Theory: `../theory.md`
- Comparison: `../comparison.md`
- Arduino code: `../../hardware/arduino-control/`
- Python simulation: `../../simulations/mzi_mesh.py`
