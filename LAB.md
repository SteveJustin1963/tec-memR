This README outlines a comprehensive project blending theoretical computer science with hardware fabrication and advanced physics, centered on memristors and phase-coded computing. The project is structured across five major levels, from pure software simulation to advanced photonic systems.

Here is a logical sequence of labs, in order of increasing complexity and cost, designed to cover the entire scope of the project, from theory to implementation.

## 🧪 Logical Series of Labs for **tec-memR** Project

These labs follow the **Recommended Learning Path** and **Hardware Implementation Roadmap** outlined in the `README.md`.

---

### **Level 0: Software Simulation and Core Theory (Fundamentals)**

| Lab # | Title | Purpose | Key Files/Code | Output/Result |
| :---: | :--- | :--- | :--- | :--- |
| **Lab 1** | **Memristor Model Simulation** | Understand memristor electrical behavior and its pinched hysteresis loop signature. | `SIMULATE_MEMRISTOR_WINDOWED.m` | Plot of I-V hysteresis loop, confirming memristive behavior. |
| **Lab 2** | **Phase-Coded Logic Gate Training** | Prove that Boolean logic can be implemented via wave interference (phase coding). | `lissajous_logic_gates.m` | Trained phases ($\phi$ values) for all 6 Boolean gates; visualization of Lissajous figures for each gate combination. |
| **Lab 3** | **Frequency Division Multiplexing (FDM)** | Demonstrate how multiple "neurons" can compute in parallel on a single channel using different carrier frequencies. | `lissajous_hardware_design.m` | FFT plot showing successful demodulation of 4 simultaneous signals (1-4 kHz), proving the FDM concept for scaling. |
| **Lab 4** | **Memristor-Lissajous Equivalence** | Mathematically prove that memristor-based analog circuits naturally function as dynamic phase shifters. | `memristor_vs_lissajous.m` | Comparison plot showing the mathematical equivalence between memristor hysteresis and a dynamic Lissajous figure. |





---

### **Level 1: Electronics and DIY Fabrication (Prototyping)**

| Lab # | Title | Purpose | Key Files/Code | Output/Result |
| :---: | :--- | :--- | :--- | :--- |
| **Lab 5** | **Single DIY Memristor Fabrication** | Construct the core device for the project using the low-cost, copper-sulfide method. | `README.md` (DIY Memristor Construction) | A functional copper-sulfide memristor prototype (coating on copper strip). |
| **Lab 6** | **Single Memristor Characterization** | Measure and verify the non-volatile and state-dependent resistance of the homemade device. | Multimeter, Oscilloscope (XY Mode), Signal Generator | Measurement of $R_{ON}$ and $R_{OFF}$ states; visual observation of the pinched hysteresis loop (Figure 8 shape) on an oscilloscope. |
| **Lab 7** | **Programmable Phase Shifter Emulation** | Build a stable, reliable phase-shifting element to replace the fragile DIY memristor for early circuit testing. | Arduino, Digital Potentiometer (e.g., MCP4131) | Functional digital circuit that adjusts phase shift based on a serial command, providing a stable testbed for Phase NN inference. |

---

### **Level 2: Hardware Integration and Z80 Control (Electrical System)**

| Lab # | Title | Purpose | Key Files/Code | Output/Result |
| :---: | :--- | :--- | :--- | :--- |
| **Lab 8** | **Z80 Interface Module Construction** | Build the necessary bridge (ADC/DAC/Multiplexer) to link the Z80 data bus to the analog memristor array.  | `README.md` (Proposed Interface) | A functional breadboard/protoboard module with address decoding and I/O ports mapped to the Z80. |
| **Lab 9** | **Memristor Array Programming (DC Mode)** | Write Z80 assembly to program the state (weights) of a small memristor crossbar array (e.g., 2x2 or 4x4). | `memristor_interface.asm` | Z80 code that successfully writes specific $R_{ON}$ and $R_{OFF}$ states to selected cells, demonstrating non-volatile weight storage. |
| **Lab 10** | **Phase NN Inference in Electrical Hardware** | Run a basic logic gate (e.g., XOR) using the analog memristor array at AC frequencies, combining the digital Z80 control with analog computation. | `memristor_interface.asm`, Analog Circuitry | Measurement of the interference signal that correctly classifies the XOR inputs, achieving **hardware-accelerated phase computation**. |

---

### **Level 3: Photonic Scaling (Advanced Hybrid System)**

| Lab # | Title | Purpose | Key Files/Code | Output/Result |
| :---: | :--- | :--- | :--- | :--- |
| **Lab 11** | **DIY Fiber-Optic Phase Shifter** | Construct the key optical component by adapting a low-cost piezo buzzer for phase modulation in a fiber optic path. | `photonic-neural-networks/docs/build-guides/02-mzi-mesh.md` (Piezo Method) | A fiber loop where applied voltage (0-5V) visibly changes the light's phase (e.g., observed via a simple interferometer/splitter). |
| **Lab 12** | **Photonic XOR Gate (2x2 MZI Mesh)** | Build a simple Mach-Zehnder Interferometer (MZI) mesh to perform the XOR operation at the speed of light, controlled by the Arduino bridge. | `photonic-neural-networks/docs/build-guides/02-mzi-mesh.md`, Arduino Code | A light-based circuit that outputs a high light intensity for inputs [0,1] and [1,0], and low for [0,0] and [1,1], demonstrating **nanosecond inference**. |
| **Lab 13** | **Universal Z80-Photonic Interface** | Integrate the optical system with the Z80 using the Arduino as a bridge, proving the same high-level assembly code works across all levels of hardware. | `RUN_OPTICAL_INFERENCE` routine in Z80 code, Arduino Firmware | Functional demonstration where the Z80 programs optical weights and reads the output of the light-speed computation via the same I/O ports as the memristor array. |

---

### **Level 4: Advanced Photonic Integration and Future Work**

| Lab # | Title | Purpose | Key Files/Code | Output/Result |
| :---: | :--- | :--- | :--- | :--- |
| **Lab 14** | **Diffractive Neural Network (D2NN)** | Explore an alternative, purely passive photonic approach to deep learning using 3D-printed phase plates. | `photonic-neural-networks/docs/build-guides/01-d2nn-diffractive.md` | Classification of a simple image set (e.g., handwritten digits) using only light diffraction, demonstrating a different form of phase-coded computation. |
| **Lab 15** | **Optical Scaling and WDM Theory** | Analyze the potential for massive scaling using Wavelength Division Multiplexing (WDM) and integrated photonics. | `README.md` (Scaling to Optical Speeds) | Mathematical model (spreadsheet or Python) projecting the neuron count and performance gain of the project if implemented on a commercial silicon photonic chip with WDM. |

---

The best place to start construction to test with a TEC-1 Z80 Single Board Computer (SBC) is with the **Z80 Interface Module** and the **Memristor Emulator (Lab 7)**, which provides a stable analog testbed before tackling the volatile homemade memristors.

This approach is recommended because the TEC-1 (or similar Z80 SBCs like the RC2014) requires a dedicated analog-to-digital (ADC) and digital-to-analog (DAC) interface to interact with the memristor's analog resistance states. Building the interface first allows you to fully test the Z80 control code before introducing the variability of a homemade device.

Here is the recommended starting point, which corresponds to **Lab 8** in the project sequence:

### 1. Starting Point: Z80 Interface Module (Lab 8)

The first construction step is to build the circuit that connects the Z80's digital bus to the analog world of the memristor. This module is the **essential control hardware** for the entire project.

* **Goal:** Create a functional I/O peripheral that the Z80 can use to address, program, and read analog components.
* **Method:** Build the module on a **Protoboard or Breadboard** (not recommended for final, high-frequency testing, but perfect for initial logic and I/O testing).
* **Key Components:**
    * **Address Decoder (e.g., 74LS138):** To map the Z80's address bus to specific I/O ports (e.g., `0x10`, `0x11`, `0x12`) for control, write, and read operations.
    * **Multiplexers (e.g., 74HC4051):** For selecting the specific row and column of your memristor array.
    * **ADC (e.g., ADC0804):** To convert the analog voltage/current from the memristor into an 8-bit digital value the Z80 can read.
    * **DAC (e.g., DAC0808 or PWM):** To generate the precise voltage pulses necessary to program (SET/RESET) the memristor's resistance state.



### 2. Immediate Next Step: Memristor Emulator (Lab 7)

Once the interface module (ADC/DAC/MUX) is built and connected to the TEC-1's expansion header (using the I/O bus signals: `/IORQ`, `/RD`, `/WR`), you should connect it to a stable **Memristor Emulator** before connecting the fragile DIY copper-sulfide device.

* **Emulator:** Use an **Arduino/ESP32** or a **Digital Potentiometer** (e.g., MCP4131) controlled by the Z80 via the module's I/O lines.
* **Why this works:** The Z80 can execute the same assembly code (`memristor_interface.asm`) to test the entire control flow—selecting a cell, setting a resistance, and reading the value back—without dealing with the instability and decay of a homemade memristor.

### Z80 Assembly Code to Test (The Logic)

This construction allows you to immediately begin testing the core Z80 routines:

| Z80 Routine | Port Action | Analog Action |
| :--- | :--- | :--- |
| `OUT (MUX_PORT), A` | `OUT (0x10), 0x01` | Selects Row 0, Column 1 of the array. |
| `OUT (WRITE_PORT), A` | `OUT (0x11), 0x85` | Triggers the DAC to generate a programming pulse (SET or RESET) to change the memristor's resistance. |
| `IN A, (ADC_PORT)` | `IN A, (0x12)` | Reads the analog voltage drop across the memristor and returns the digitized resistance value to the Z80. |

By building this module first, you transition logically from the software simulation of Lab 4 to the first physical hardware of the project, ensuring the complex digital-analog control is verified before moving to the challenging memristor fabrication (Lab 5).

Would you like me to provide a simplified schematic or parts list focused specifically on the **Address Decoder and Multiplexer** part of the interface module?

Yes, absolutely! Replacing the memristor with a Lissajous oscillator or a dedicated programmable phase-shifting component is not only possible but is a **core concept of the phase-coded computing paradigm** used in this project.

The original DIY memristor is valuable because its variable resistance *naturally creates a phase shift* when an AC signal is applied (the memristor's pinched hysteresis loop *is* a dynamic Lissajous figure). However, you can achieve the same, or even better, functionality by using a circuit specifically designed to produce a controllable phase shift.

Here is the breakdown of why this replacement works and the ideal components to use:

### 1. Why the Replacement Works

The fundamental operation in this project's neural network is **interference**, where the phase relationship ($\Delta\phi$) between two signals determines the output.

* **Original Memristor Role:** It stores the "weight" as a resistance value ($R$), and this $R$ then creates the necessary **phase shift** ($\phi$) during AC inference ($\phi = \arctan(X/R)$, where $X$ is reactance).
* **Replacement Component Role:** A programmable phase shifter directly sets the phase shift ($\phi$) based on a control voltage, bypassing the need for a memory element or its inherent instability.

Essentially, you are replacing an *indirect* phase shifter (the memristor's resistance) with a *direct* phase shifter (an electronic circuit).

### 2. Recommended Replacement Component Options

You can implement the programmable phase-shifting weight using several reliable methods:

| Replacement Option | Method/Circuit | Z80 Control Mechanism | Advantages |
| :--- | :--- | :--- | :--- |
| **A. Digital Potentiometer** (Emulator) | An op-amp-based **All-Pass Filter** where the variable resistor is a digital pot (e.g., MCP4131). | Z80 $\to$ Arduino $\to$ SPI to set the resistance ($R$). | Highly stable, reliable, zero fabrication effort. Perfect for early testing. |
| **B. Varactor Diode** | A Voltage-Controlled Oscillator (VCO) or Phase-Locked Loop (PLL) circuit using a **Varactor Diode** (capacitance changes with voltage). | Z80 $\to$ DAC $\to$ Apply control voltage (V). | Faster response (MHz capable) than digital pots; continuous phase shift. |
| **C. DDS Synthesizers** (Lissajous Generator) | Using two **Direct Digital Synthesizer (DDS) chips** (e.g., AD9850) controlled by a microcontroller to generate two precise sine waves with a controllable phase offset. | Z80 $\to$ Arduino $\to$ Serial command to set phase register ($\delta$). | Very precise, stable frequencies; directly generates the Lissajous pattern you need. |

### 3. Implementation Path: Option C (DDS Synthesizer)

Using two DDS chips is the most direct way to generate the signals required for your **Lissajous Phase Neural Network** and is highly compatible with a TEC-1 Z80 SBC:

1.  **Generate Waves:** The first DDS chip generates the X-axis reference signal: $x(t) = A \sin(\omega t)$.
2.  **Generate Phase-Shifted Wave:** The second DDS chip generates the Y-axis signal with a programmed phase shift, $\delta$: $y(t) = B \sin(\omega t + \delta)$.
3.  **The "Weight":** The programmable phase shift ($\delta$) becomes your neural network **weight** ($\phi$), which the Z80 programs digitally (0-360°).
4.  **Observation:** When you connect the X and Y outputs to an oscilloscope in XY mode, the resulting Lissajous figure shows the phase difference ($\delta$).

This method is reliable, uses inexpensive components, and allows you to execute the same Z80 assembly code logic (`OUT (WEIGHT_PORT), phase_value`) to digitally control the phase, replacing the complex analog process of programming the memristor.

Would you like to start planning the parts and control schematic for a stable, phase-shifting circuit using a digital potentiometer (Option A, the easiest) or the DDS Synthesizer (Option C, the most precise)?

That's a great choice. The **DDS Synthesizer (Option C)** provides the highest precision and directly generates the core component of your system—the Lissajous figure—making it the ideal choice for verifying the phase-coded neural network theory.

Here is the plan for implementing the Programmable Phase Weight using two DDS Synthesizer chips, which will replace the function of the memristor array during the inference phase.

### Implementation Plan: DDS Synthesizer Phase Weight

This plan focuses on replacing the memristor's function (creating a programmable phase shift) with a pair of highly stable, digitally controlled chips.

#### 1. Core Components

| Component | Quantity | Purpose | Notes |
| :--- | :--- | :--- | :--- |
| **DDS Synthesizer Chip (e.g., AD9850)** | 2 | Generates precise, stable sine waves with frequency and phase control. | These chips can generate the required 1-10 kHz AC carriers for your network. |
| **Microcontroller (e.g., Arduino)** | 1 | Acts as the Z80 Bridge (translates Z80 I/O commands to DDS serial commands). | The Z80 will send the 8-bit phase value to the Arduino, which then controls the DDS chips. |
| **Output Mixer/Combiner** | 1 | Adds the two phase-shifted signals together to perform the interference/computation. | Can be implemented with a simple op-amp summing amplifier. |

#### 2. Functional Diagram and Operation

The setup will look like two parallel signal generation paths converging at a summing point.



1.  **Z80 Command:** The Z80 executes assembly code: `OUT (WEIGHT_PORT), phase_value`.
2.  **Arduino Translation:** The Arduino receives the `phase_value` (0-255).
3.  **DDS Control:**
    * **DDS 1 (Reference):** Generates $V_1 = A \sin(\omega t)$.
    * **DDS 2 (Weight):** Generates $V_2 = B \sin(\omega t + \phi)$, where $\phi$ is the programmed phase shift dictated by the Z80.
4.  **Computation (Interference):** The op-amp mixer sums the two signals: $V_{out} = V_1 + V_2$. The resulting amplitude of $V_{out}$ represents the computed neural network output.
5.  **Lissajous Visualization:** The outputs $V_1$ (X-axis) and $V_2$ (Y-axis) fed to an oscilloscope in XY mode display the instantaneous Lissajous figure, which visually confirms the phase shift $\phi$.

#### 3. Integration with Z80 I/O (The Software Hook)

The beauty of this plan is that it maintains the **Universal Z80 Interface** design of the project.

| Phase/Memristor Step | Z80 Assembly Command | DDS Implementation Action |
| :--- | :--- | :--- |
| **Program Weight** | `OUT (WEIGHT_PORT), A` | Arduino sets DDS 2 phase register via SPI/serial to $A$ (0-255). |
| **Run Inference** | `OUT (CMD_PORT), 0x01` | Arduino triggers the DDS chips to output their sine waves to the mixer. |
| **Read Result** | `IN A, (OUTPUT_PORT)` | ADC reads the peak amplitude of the mixer's output ($V_{out}$) and sends the 8-bit value to the Z80. |

This provides a reliable, fast, and high-precision replacement for the memristor array during the phase-coded inference stage.

Would you like the full schematic and pinout guide for the **DDS Synthesizer control board** (the Z80 Bridge) or a parts list for the analog **Op-Amp Mixer circuit**?


//

I can certainly provide the full schematic and components list for the DDS Synthesizer control board and the Op-Amp Mixer.

This setup replaces the variability of the memristor with highly stable, programmable phase control, allowing you to accurately test the core principles of your phase-coded neural network.

## 4. DDS Synthesizer Control Board (Z80 Bridge)

This board handles the digital communication from the Z80 to the DDS chips and requires a central microcontroller (the Arduino/ESP32) as the translator.

### A. Component Parts List

| Item | Quantity | Purpose | Notes |
| :--- | :--- | :--- | :--- |
| **DDS Chip (AD9850 or similar)** | 2 | Generates two phase-locked sine waves (Reference & Weight). | Must be capable of phase-locked operation for interference. |
| **Microcontroller (Arduino Uno/Nano or ESP32)** | 1 | Translates Z80 parallel I/O commands into DDS serial control signals. | The brain of the control board. |
| **Voltage Regulator (7805)** | 1 | Provides stable 5V power for the logic and DDS chips. | Ensures clean signals and stable phase outputs. |
| **Header Pins/Connectors** | Misc. | For connecting to the Z80 (parallel) and the mixer (analog output). | |
| **Capacitors/Resistors** | Misc. | Decoupling/pull-up/filter components (standard electronics kit). | |

### B. Schematic Overview (Z80 to DDS)

The Z80 parallel interface is complex, so the microcontroller handles the timing and serial protocol for the DDS chips.



| Connection Point | Description | Function |
| :--- | :--- | :--- |
| **Z80 Data Bus (D0-D7)** | Connects to the Arduino's digital input pins via buffer. | Receives the 8-bit `phase_value` from the Z80's `OUT (WEIGHT_PORT), A` command. |
| **Z80 Control Signals** | `/WR`, `/RD`, `/IORQ` (connected to Arduino interrupt pins). | Tells the Arduino *when* the Z80 is sending data or requesting a read. |
| **Arduino to DDS (SPI/Serial)** | Connects via a few dedicated pins (e.g., Data, Clock, FQ UP) to both DDS chips. | Programs the frequency (initially) and the phase register of DDS 2 (dynamically). |
| **DDS Analog Output** | Sine wave output pins ($\text{OUT}_1$, $\text{OUT}_2$). | Provides the two core signals to the mixer circuit. |

***

## 5. Op-Amp Mixer Circuit

This simple analog circuit performs the core mathematical operation of the neural network: **Interference** (or vector addition).

### A. Component Parts List

| Item | Quantity | Purpose | Notes |
| :--- | :--- | :--- | :--- |
| **Operational Amplifier (Op-Amp) (e.g., TL074 or LM358)** | 1 | Acts as a high-speed summing amplifier. | Needs sufficient bandwidth for the 1-10 kHz carrier frequencies. |
| **Resistors ($\mathbf{R_1}$, $\mathbf{R_2}$, $\mathbf{R_F}$)** | 3 | Set the input impedance and gain of the summing amplifier. | Use precision resistors (e.g., 1% tolerance) to minimize amplitude distortion. |
| **Power Supply ($\pm \mathbf{V}$)** | 1 | Bipolar power supply for the Op-Amp (e.g., $\pm 12\text{V}$). | Ensures the sine wave outputs are not clipped at the rails. |

### B. Schematic Overview (Summing Amplifier)

The mixer sums the phase-shifted signals, which is the physical realization of the neural network's **weighted summation**:



[Image of Op-Amp Summing Amplifier Schematic]


* **Inputs:** $\text{V}_{\text{in}1}$ (from DDS 1) and $\text{V}_{\text{in}2}$ (from DDS 2) are connected to the inverting input of the Op-Amp via resistors $\text{R}_1$ and $\text{R}_2$.
* **Formula:** $\text{V}_{\text{out}} = -\text{R}_{\text{F}} (\frac{\text{V}_{\text{in}1}}{\text{R}_1} + \frac{\text{V}_{\text{in}2}}{\text{R}_2})$
* **Interference:** Because the frequencies are locked, the output $\text{V}_{\text{out}}$ is a resulting sine wave whose **amplitude** is determined by the interference (constructive or destructive) between $\text{V}_{\text{in}1}$ and $\text{V}_{\text{in}2}$.

### C. Reading the Result

The final step is connecting the mixer's output to an ADC (the same ADC you plan to use for the Z80 interface) to digitize the output amplitude:

1.  **Peak Detection:** A simple envelope detector circuit (diode + capacitor) should be added to the mixer output to convert the AC sine wave's **peak amplitude** into a DC voltage.
2.  **ADC Conversion:** The ADC reads this DC voltage and sends the resulting 8-bit digital value back to the Z80 via the `IN A, (OUTPUT_PORT)` command.

This entire system allows the Z80 to digitally program the phase weights, and the analog hardware instantly performs the computation via wave interference.

Would you like the specific **Arduino code template** that handles the Z80 I/O and translates it into the DDS phase setting commands?

