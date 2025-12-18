# Photonic Neural Networks - DIY Implementation Guide

## Overview
This project focuses on building practical photonic neural networks using affordable DIY methods. We're extracting and implementing the photonic computing concepts from the main memR project.

## Project Goals
1. Build functional photonic neural networks using optical interference
2. Implement phase-based computing similar to commercial systems (Lightmatter, NTT)
3. Create practical demonstrations at low cost ($30-500 depending on approach)
4. Bridge the gap between theoretical phase computing and hands-on implementation

## Main Approaches

### 1. Diffractive Deep Neural Network (D2NN)
- **Cost**: $30-100
- **Difficulty**: Easiest
- **Method**: 3D-printed phase plates
- **Speed**: Speed of light through plastic
- **Based on**: UCLA Ozcan group designs

### 2. Mach-Zehnder Interferometer (MZI) Mesh
- **Cost**: $200-500
- **Difficulty**: Medium-Hard
- **Method**: Bulk optics with beam splitters and mirrors
- **Speed**: Limited by phase modulators (~1kHz - 1MHz)
- **Based on**: Clements mesh architecture (like Lightmatter chips)

### 3. LCOS/SLM Based System
- **Cost**: $50-150
- **Difficulty**: Medium
- **Method**: Salvaged liquid crystal display as programmable phase modulator
- **Speed**: 60 fps (video refresh rate)
- **Based on**: Repurposed projector components

### 4. Coherent Ising Machine (CIM)
- **Cost**: $150-250
- **Difficulty**: Medium-Hard
- **Method**: Optical phase annealing with feedback
- **Speed**: Milliseconds to seconds to converge
- **Based on**: NTT's commercial CIM systems

## Connection to Parent Project (memR)
- Phase computing theory developed in Lissajous simulations applies directly
- Training algorithms from `lissajous_logic_gates.m` work for all photonic systems
- Memristor crossbar = electrical analog of photonic MZI mesh
- Same underlying mathematics: `Output = Σ A_i · sin(ωt + φ_i)`

## Project Structure
```
photonic-neural-networks/
├── README.md (this file)
├── docs/
│   ├── theory.md
│   ├── comparison.md
│   └── build-guides/
├── designs/
│   ├── d2nn/
│   ├── mzi-mesh/
│   ├── lcos-slm/
│   └── coherent-ising/
├── simulations/
└── hardware/
    ├── parts-lists/
    ├── schematics/
    └── calibration/
```

## Next Steps
1. Extract detailed build guides from main README
2. Create simulation models for each approach
3. Design 3D printable components for D2NN
4. Source parts and create shopping lists
5. Build and test prototypes

## References
- Parent project: `/home/steve/memR/`
- Main README: `/home/steve/memR/README.md`
- Lissajous simulations: `/home/steve/memR/lissajous_*.m`
