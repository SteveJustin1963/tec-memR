# Diffractive Deep Neural Network (D2NN) Build Guide

## Overview
The simplest photonic neural network you can build. Uses 3D-printed phase plates to perform all-optical inference.

**Difficulty**: Beginner+
**Cost**: $30-100
**Time**: 1 afternoon to 1 weekend
**Based on**: UCLA Ozcan group designs (published in Science/Nature)

## How It Works

1. **3D-print plastic plates** with tiny bumps/features
2. Each bump adds a **phase delay** (0 to 2π) to light passing through
3. **Laser shines** through the stack of plates
4. **Free-space diffraction** performs matrix multiplications automatically
5. Final **intensity pattern** on camera = classification result

### Example Application
- Recognizes handwritten digits 0-9 (MNIST dataset)
- 88-91% accuracy with 5-layer version
- Inference happens at **speed of light** through plastic!

## Parts List

| Item | Cost | Source | Notes |
|------|------|--------|-------|
| Laser pointer (532nm green or 650nm red) | $3-10 | eBay/Amazon | 1-5mW safe power |
| 3D printer access | $0-50 | Makerspace/online service | Or own printer |
| PLA/resin filament (clear preferred) | $10-20 | Standard 3D printing | Resin gives better phase accuracy |
| Old webcam or phone camera (no lens) | $0-10 | Junk drawer/eBay | Just need sensor |
| Cardboard tube or 3D-printed holder | Free-$10 | DIY | For alignment |
| **Total** | **$30-100** | | |

## Pre-Made Designs

### GitHub/Thingiverse
Search for:
- "diffractive deep neural network STL"
- "Ozcan diffractive D2NN 3D print"
- "MNIST optical classifier 3D print"

### Popular Designs (2024-2025)
1. **5-layer MNIST classifier** - 88-91% accuracy
2. **Fashion-MNIST classifier** - 85% accuracy
3. **Vowel recognition** - 3 layers
4. Most include alignment jigs

## Build Steps

### 1. Download Design Files
- Get STL files from GitHub/Thingiverse
- Check that it includes alignment features
- Read any calibration notes from designer

### 2. 3D Print the Plates
**Settings for PLA:**
- Layer height: 0.1-0.2mm
- Infill: 100%
- Material: Clear PLA (or standard if clear not available)

**Settings for Resin (better):**
- Layer height: 0.05mm
- Material: Clear resin
- Post-cure properly

**Critical**: Print quality affects accuracy!

### 3. Clean and Post-Process
- Remove supports carefully
- Sand any rough edges (don't touch feature surface!)
- For resin: wash and UV cure per manufacturer specs

### 4. Build Alignment Jig
- Either print included jig or:
- Use cardboard tube (paper towel tube works)
- Ensure plates are:
  - Parallel to each other
  - Perpendicular to laser beam
  - Spaced as specified in design (~5-20mm typical)

### 5. Set Up Optical Path

```
[Laser] ---> [Plate 1] --- [Plate 2] --- [Plate 3] --- ... --- [Plate N] ---> [Camera]
              (5-20mm)     (5-20mm)     (5-20mm)              (50-100mm)
```

**Tips:**
- Mount laser securely (won't move)
- Align beam through center of all plates
- Camera should see entire output pattern
- Work in dim/dark room for better contrast

### 6. Calibration

**Test Pattern Method:**
1. Shine laser through plates
2. Should see interference pattern on screen/camera
3. Adjust plate spacing until pattern is clear
4. Take reference image

**Digit Recognition Test:**
1. Create input digit pattern (print on transparency)
2. Place at input plane (before first plate)
3. Observe output pattern on camera
4. Different digits should give different patterns

### 7. Data Collection
- Test all 10 digits (0-9)
- Record output patterns
- Check accuracy against known labels
- Typical results: 80-90% for well-printed designs

## Troubleshooting

| Problem | Cause | Solution |
|---------|-------|----------|
| Blurry output | Plates not parallel | Check alignment jig |
| No pattern visible | Laser not aligned | Center beam through all plates |
| Low accuracy (<70%) | Poor print quality | Reprint with higher resolution |
| Inconsistent results | Vibrations | Secure all components |
| Dim output | Laser too weak | Use 3-5mW laser |

## Performance Specs

- **Latency**: ~nanoseconds (limited by light speed through ~10-30cm plastic)
- **Accuracy**: 88-94% on MNIST (depends on print quality)
- **Layers**: 3-10 layers typical
- **Neurons**: ~100,000 effective (pixel-level features)
- **Power**: <100mW (just laser power)
- **Throughput**: 1 inference per setup (passive device)

## Advanced: Training Your Own Design

If you want to design custom plates (not use pre-made):

### Software Needed
- Python with TensorFlow/PyTorch
- Optical simulation library (Rayleigh-Sommerfeld diffraction)
- 3D modeling software (OpenSCAD, Blender)

### Training Process
1. Define task (e.g., classify 4 letters)
2. Simulate light propagation through phase plates
3. Optimize plate features using backpropagation
4. Export height map as STL
5. Print and test

**Note**: This is advanced - recommend starting with pre-made designs!

## Comparison to Other Approaches

| Feature | D2NN | MZI Mesh | LCOS/SLM |
|---------|------|----------|----------|
| Cost | $ | $$$ | $$ |
| Speed | Fast | Fast | Medium |
| Reconfigurable | No | Yes | Yes |
| Accuracy | Good | Excellent | Excellent |
| Build difficulty | Easy | Hard | Medium |

**D2NN Advantages:**
- Cheapest option
- Easiest to build
- No electronics needed (passive)
- Great for learning/demos

**D2NN Limitations:**
- Fixed after printing (can't retrain)
- Need new plates for new tasks
- Sensitive to alignment
- Lower accuracy than electronic NNs

## Next Steps

1. **Start simple**: Download and print a pre-made design
2. **Test and learn**: Get familiar with optical alignment
3. **Experiment**: Try different spacing, lasers, inputs
4. **Advanced**: Design your own custom classifier

## References

- UCLA Ozcan Group papers on D2NN
- GitHub: search "diffractive neural network"
- Thingiverse: MNIST optical classifier designs
- Parent project: `/home/steve/memR/lissajous_logic_gates.m` (phase training theory)

## Related Files in This Project

- Theory: `../theory.md`
- Comparison: `../comparison.md`
- Next step: Try MZI mesh for reconfigurable network
