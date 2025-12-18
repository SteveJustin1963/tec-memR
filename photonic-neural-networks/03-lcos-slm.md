# LCOS/SLM Photonic Neural Network Build Guide

## Overview
The "cheat" version - use a salvaged liquid crystal display as a programmable phase modulator for instant reconfigurable photonic computing.

**Difficulty**: Medium
**Cost**: $50-150
**Time**: 1-2 weekends
**Based on**: Repurposed projector technology

## What is LCOS/SLM?

**LCOS** = Liquid Crystal on Silicon
**SLM** = Spatial Light Modulator

These devices can control light phase at each pixel independently:
- 1920×1080 = **2,073,600 programmable phase shifters!**
- Each pixel can apply 0 to 2π phase shift
- Control via HDMI signal (treat like a monitor)
- Originally designed for projectors/displays

## How It Works for Neural Networks

```
Laser → [Collimating lens] → [LCOS panel] → [Fourier lens] → [Camera/photodiode]
                               (displays pattern)     (focuses result)
```

1. **Input data** → displayed as grayscale pattern on LCOS
2. **Laser illuminates** the panel
3. Each pixel **shifts light phase** based on brightness
4. **Lens performs optical Fourier transform** (matrix multiplication!)
5. **Camera captures** output pattern
6. **Computer reads** result

**One video frame = one neural network layer!**

## Key Advantage

Unlike D2NN (fixed after printing) or MZI mesh (complex alignment), LCOS is:
- ✅ **Fully programmable** - change network in milliseconds
- ✅ **High resolution** - millions of weights
- ✅ **Easy setup** - just laser + lenses + LCOS
- ✅ **60 fps** - video refresh rate = inference rate

## Parts List

| Item | Cost | Source | Notes |
|------|------|--------|-------|
| **Core Components** |
| LCOS panel from broken projector | $30-60 | eBay/AliExpress | Search "1080p LCOS module" |
| OR: New HDMI LCOS module | $60-120 | AliExpress | Easier but pricier |
| Laser diode module (635nm or 532nm, <5mW) | $10-20 | Amazon/eBay | Red works best with most LCOS |
| Collimating lens (25-50mm focal length) | $10-20 | Amazon/Surplus | Expand beam to cover panel |
| Fourier lens (50-100mm focal length) | $15-30 | Amazon/Surplus | Performs optical transform |
| **Detection** |
| Webcam (no lens) OR CCD sensor | $10-20 | Amazon/salvage | For reading output |
| OR: Photodiode array | $15-30 | Adafruit | For specific outputs |
| **Mechanical** |
| Optical rail or 3D-printed base | $20-40 | Amazon/print | Alignment |
| Lens mounts (3× for laser, 2× lenses) | $15 | Amazon/print | Stability |
| **Electronics** |
| HDMI signal source (Raspberry Pi, old laptop, HDMI stick) | $0-35 | You have/cheap | To drive LCOS |
| **Safety** |
| Laser goggles | $10-20 | Amazon | Eye protection |
| **Total** | **$50-150** | | Depends on salvage vs new |

## Salvaging LCOS from Projectors

### Where to Find
- Broken mini projectors on eBay
- Pico projectors (Sony MP-CL1, Celluon PicoPro)
- Check local e-waste centers
- Buy "parts only" projectors cheap

### Disassembly Steps
1. Open projector case (usually screws under rubber feet)
2. Locate LCOS chip (small reflective square, ~0.5-1 inch)
3. Find HDMI driver board
4. Carefully desolder/disconnect
5. Remove LED assembly (not needed)
6. Keep: LCOS panel + driver board + HDMI input
7. Test: Connect HDMI, display test pattern

**Warning**: LCOS is delicate - don't touch surface!

### Wavelength Considerations
Most LCOS optimized for:
- **635nm (red)** - Best for consumer LCOS
- **532nm (green)** - Works but less efficient
- **450nm (blue)** - Often poor phase shift

**Tip**: Match laser wavelength to LCOS coating (check specs or test)

## Build Steps

### 1. LCOS Setup and Testing (Day 1)

**Hardware connections:**
```
[HDMI source] → LCOS driver board → LCOS panel
```

**Software test:**
1. Connect LCOS as second monitor
2. Display grayscale test pattern (0-255 levels)
3. Should see reflected image (LCOS is reflective)

**Verify it's working:**
- Display checkerboard → see checkerboard in reflection
- Display gradient → see smooth gradient
- No dead pixels (or note them)

### 2. Phase Calibration (Day 1-2)

**Critical step**: Map pixel brightness → phase shift

**Setup:**
```
Laser → [Polarizer] → LCOS (at angle) → [Analyzer] → Photodiode
```

**Process:**
1. Display uniform gray level (0-255)
2. Measure transmitted intensity
3. Repeat for all 256 levels
4. Plot: Intensity vs gray level
5. Should see sinusoidal curve (interference)
6. Extract: Gray level → phase shift (0 to 2π)

**Python code:**
```python
import cv2
import numpy as np

# Display calibration pattern
gray_values = np.arange(0, 256, 1)
phase_shifts = []

for gray in gray_values:
    pattern = np.ones((1080, 1920), dtype=np.uint8) * gray
    display_on_lcos(pattern)  # Via HDMI
    intensity = measure_photodiode()
    phase_shifts.append(intensity)

# Find phase calibration curve
phase_map = fit_sinusoid(gray_values, phase_shifts)
save_calibration(phase_map)
```

**Result**: Lookup table (LUT) for gray → phase

### 3. Optical Setup (Day 2)

**Configuration:**
```
                            [LCOS panel]
                                 ↕ (reflects)
[Laser] → [Expand] → [Collimate] → [Polarizer]
                                          |
                                          ↓
                                   [Fourier lens]
                                          |
                                          ↓
                                      [Camera]
```

**Alignment steps:**
1. **Mount laser**: Fixed position
2. **Expand beam**: Use lens to ~10-20mm diameter
3. **Collimate**: Ensure parallel light (test with mirror)
4. **Polarizer**: Set to 45° (or calibrated angle)
5. **LCOS**: At 45° angle to beam (for reflection)
6. **Fourier lens**: 1-2 focal lengths from LCOS
7. **Camera**: At focal plane of lens

**Test**: Display simple pattern (circle), see Fourier transform on camera

### 4. Programming Neural Network Patterns (Day 3-4)

**Concept**: Pixel pattern encodes weight matrix

**For fully connected layer:**
```python
# Example: 4→4 layer
weights = np.random.randn(4, 4)  # Trained weights

# Convert to phase pattern
phase_pattern = weights_to_phase(weights, phase_map)

# Scale to full LCOS resolution
lcos_pattern = upscale_to_1080p(phase_pattern)

# Display on LCOS
display_hdmi(lcos_pattern)
```

**For convolution:**
- Display convolution kernel as phase pattern
- Input image as amplitude (via another SLM or printed)
- Output is convolution (via Fourier optics)

### 5. Inference Pipeline (Day 4-5)

**Python example:**
```python
import numpy as np
import cv2
from lcos_driver import LCOS

# Initialize
lcos = LCOS(hdmi_device='/dev/video0')
camera = cv2.VideoCapture(1)
phase_calibration = load_calibration()

# Load trained network weights
W1 = load_weights('layer1.npy')  # 784 → 128
W2 = load_weights('layer2.npy')  # 128 → 10

def inference(input_data):
    # Layer 1
    pattern1 = weights_to_lcos(W1, phase_calibration)
    lcos.display(pattern1)
    time.sleep(0.016)  # Wait one frame (60fps)

    output1 = camera.read()  # Capture Fourier transform
    features1 = extract_features(output1)  # Read intensity
    features1 = relu(features1)  # Nonlinearity on CPU

    # Layer 2
    pattern2 = weights_to_lcos(W2, phase_calibration)
    lcos.display(pattern2)
    time.sleep(0.016)

    output2 = camera.read()
    features2 = extract_features(output2)

    # Softmax on CPU
    prediction = softmax(features2)
    return prediction

# Test on MNIST
digit_image = load_mnist_test(index=0)
result = inference(digit_image)
print(f"Predicted: {np.argmax(result)}")
```

**Performance:**
- 60 fps = 16.6ms per layer
- 3-layer network = ~50ms inference
- Much faster than CPU for large matrices!

### 6. Training Integration (Advanced)

**Hybrid approach:**
- Forward pass: Optical (LCOS)
- Backward pass: CPU (standard backprop)
- Update LCOS patterns each epoch

**Process:**
```python
for epoch in range(100):
    for batch in data_loader:
        # Forward pass (optical)
        outputs = optical_forward(batch, lcos, camera)

        # Backward pass (CPU)
        gradients = compute_gradients(outputs, targets)

        # Update weights
        weights -= learning_rate * gradients

        # Reprogram LCOS
        update_lcos_patterns(weights)
```

## Advanced Techniques

### 1. Amplitude + Phase Encoding
Use two LCOS panels:
- First: Controls amplitude (intensity)
- Second: Controls phase
- More expressive than phase-only

### 2. Multi-Wavelength
Use RGB lasers:
- Red channel: One layer
- Green channel: Another layer
- Blue channel: Third layer
- Parallel processing!

### 3. Temporal Multiplexing
Display patterns at 60fps:
- Frame 1: Layer 1 weights
- Frame 2: Layer 2 weights
- Frame 3: Layer 3 weights
- Cycle through, camera synchronized

### 4. 4f System
Classic optical correlator:
```
Input → [Lens] → [LCOS filter at Fourier plane] → [Lens] → Output
```
Performs pattern matching at light speed!

## Example Applications

### 1. MNIST Classification
- **Accuracy**: 97%+ possible
- **Speed**: 60 fps (real-time)
- **Network**: 784 → 128 → 10

### 2. Real-Time Object Detection
- Use YOLO-style weights
- Process video stream
- Limited by camera fps

### 3. Optical Pattern Matching
- Store reference patterns
- Compare incoming images
- Security/biometric applications

### 4. Quantum Simulation
- Program quantum gate matrices
- Simulate small quantum circuits
- Educational tool

## Troubleshooting

| Problem | Cause | Solution |
|---------|-------|----------|
| No image on LCOS | Wrong HDMI mode | Try different resolutions |
| Phase shift too small | Wrong wavelength | Match laser to LCOS specs |
| Uneven illumination | Beam not collimated | Adjust collimating lens |
| Low contrast | Polarization wrong | Rotate polarizer |
| Flickering output | Refresh rate | Sync camera to 60fps |
| Dead pixels | Panel damage | Software interpolation |

## Performance Specs

- **Resolution**: 1920×1080 = 2M weights
- **Refresh rate**: 60 fps typical (some reach 240fps)
- **Phase depth**: 8-bit (256 levels) → ~π phase shift
- **Wavelength**: 450-650nm (depends on panel)
- **Power**: ~5W (laser + LCOS driver)
- **Latency**: 16ms per layer (60fps)
- **Accuracy**: 95-99% (comparable to digital)

## Cost Comparison

| Approach | Resolution | Reconfigurable | Cost |
|----------|------------|----------------|------|
| D2NN | ~100k | No | $30 |
| MZI 4x4 | 16 | Yes | $350 |
| LCOS | 2M | Yes | $100 |

**LCOS wins on programmability per dollar!**

## Limitations

- **Wavelength specific**: Calibration per laser color
- **Phase depth**: Only ~π shift (not full 2π for most)
- **Polarization sensitive**: Needs controlled polarization
- **Fourier only**: Best for frequency-domain operations
- **Not unitary**: Some operations not possible (vs MZI)

## Advantages

- ✅ **Millions of weights** in tiny device
- ✅ **Reconfigure in milliseconds** (new network instantly)
- ✅ **No alignment hell** (unlike MZI mesh)
- ✅ **Standard HDMI interface** (easy programming)
- ✅ **Compact** (fits in hand)
- ✅ **Low power** (~5W vs kilowatts for GPU)

## Next Steps

1. **Start with salvaged LCOS** - cheapest entry
2. **Master calibration** - critical for accuracy
3. **Implement simple classifier** - learn the pipeline
4. **Explore 4f systems** - optical pattern matching
5. **Try multi-wavelength** - parallel processing
6. **Combine with memristor** - hybrid analog/optical

## References

- Fourier optics textbooks (Goodman, etc.)
- "Optical Neural Networks" papers (2018-2025)
- YouTube: DIY SLM projects
- Parent project: `/home/steve/memR/lissajous_logic_gates.m`
- Phase theory: Same math as MZI mesh!

## Related Files

- Theory: `../theory.md`
- Python driver: `../../hardware/lcos-driver/`
- Calibration scripts: `../../hardware/calibration/lcos_calibration.py`
