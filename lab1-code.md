// --- Z80 Interface Pins (Assumed Parallel Port Mapping) ---
#define Z80_DATA_PORT   PORTD  // Arduino Port D (Pins 0-7) connected to Z80 D0-D7
#define Z80_WR_PIN      2      // Z80 Write Strobe (Active LOW) - Connect to Interrupt Pin
#define Z80_CS_PIN      3      // Z80 Chip Select (Active LOW) - Check this first

// --- DDS AD9850 Control Pins (SPI) ---
#define WCLK_PIN        8      // Word Load Clock (FQ UP)
#define FQUD_PIN        9      // Frequency Update (same as WCLK for AD9850)
#define DATA_PIN        10     // Serial Data Input
#define RESET_PIN       11     // Reset Pin

// --- System Constants ---
#define FREQUENCY       5000L  // Carrier frequency in Hz (e.g., 5 kHz)
#define PHASE_MAX_BITS  32     // DDS phase register is 5 bits (0-31), but we scale our 8-bit input.
#define Z80_PHASE_PORT  0x21   // The I/O Port address the Z80 uses to write phase (must be decoded externally)

// We use 5 bits for phase in the AD9850 (360 / 32 steps = 11.25 degrees per step)
// Z80 sends 0-255. We need to scale that down to 0-31.
#define Z80_TO_DDS_SCALE 8
```

### 2\. Global Variables

```cpp
volatile uint8_t received_data = 0;
volatile bool write_pending = false;

// DDS Control Functions - Adapted for Arduino (simplified for this context)
void sendBit(bool state) {
  digitalWrite(DATA_PIN, state ? HIGH : LOW);
  delayMicroseconds(1);
}

void pulsePin(int pin) {
  digitalWrite(pin, HIGH);
  digitalWrite(pin, LOW);
}

void writeDDS(uint32_t data) {
  for (int i = 0; i < 40; i++) { // AD9850 requires 40 bits total
    sendBit((data >> i) & 0x01);
  }
  pulsePin(FQUD_PIN); // Load the word
}
```

### 3\. Initialization (`setup()`)

```cpp
void setup() {
  // Set control pins as outputs
  pinMode(WCLK_PIN, OUTPUT);
  pinMode(FQUD_PIN, OUTPUT);
  pinMode(DATA_PIN, OUTPUT);
  pinMode(RESET_PIN, OUTPUT);
  
  // Initialize Serial for debugging
  Serial.begin(115200);
  Serial.println("DDS Bridge Initializing...");

  // Set Port D (Z80 Data Bus) to Input Mode
  DDRD = 0x00; 
  
  // Set Z80 control pin to input (with pull-up, assuming active low)
  pinMode(Z80_WR_PIN, INPUT_PULLUP);
  
  // Attach interrupt to Z80 Write Strobe Pin (for data capture)
  // Assumes we have external Z80 address decoding that uses Z80_CS_PIN
  // We use a simple pin change interrupt for the Z80_WR_PIN
  attachInterrupt(digitalPinToInterrupt(Z80_WR_PIN), captureZ80Write, FALLING); 

  // Reset and initialize the DDS chips
  resetDDS();
  setFrequency(FREQUENCY, 0); // DDS 1: Reference (0 phase)
  setFrequency(FREQUENCY, 1); // DDS 2: Weight (will be updated dynamically)
  
  Serial.println("DDS Bridge Ready for Z80 commands.");
}
```

### 4\. Main Loop (`loop()`) and Interrupt Handler

```cpp
void loop() {
  if (write_pending) {
    // 1. Convert the 8-bit Z80 input (0-255) to the DDS phase step (0-31)
    uint8_t dds_phase_step = received_data / Z80_TO_DDS_SCALE;
    
    // 2. Program the phase of the second DDS chip (the "weight")
    setPhase(dds_phase_step, 1); // Apply the phase to DDS 2 (Weight)
    
    // 3. Log the action (for debug)
    Serial.print("Z80 Phase (0-255): ");
    Serial.print(received_data);
    Serial.print(" -> DDS Phase Step (0-31): ");
    Serial.println(dds_phase_step);
    
    // 4. Reset flag
    write_pending = false;
  }
  
  // You could add periodic health checks or other tasks here
}

// --- Interrupt Service Routine (ISR) ---
void captureZ80Write() {
  // This is a minimal check. In a full system, you would check the
  // Z80 Address Bus pins to ensure the correct I/O port (0x21) was selected.
  // For simplicity here, we assume every Z80_WR trigger is meant for us.
  
  // Check Chip Select (CS) first (optional, for noise rejection)
  if (digitalRead(Z80_CS_PIN) == LOW) {
    // Read the 8-bit data from the Z80 Data Bus
    received_data = Z80_DATA_PORT; 
    write_pending = true;
  }
}
```

### 5\. DDS Control Functions (Simplified Placeholders)

```cpp
// --- DDS Control Functions (Simplified) ---

void resetDDS() {
  // Simple reset sequence
  digitalWrite(RESET_PIN, LOW);
  delay(1);
  digitalWrite(RESET_PIN, HIGH);
  delay(1);
}

void setFrequency(long freq_hz, int chip_id) {
  // Calculate the 32-bit frequency tuning word (FTW)
  // FTW = floor((Frequency * 2^32) / 125000000)
  // This is placeholder; requires a proper AD9850 library for full implementation.
  uint32_t ftw = (uint32_t)((freq_hz * 4294967296.0) / 125000000.0);
  
  // Placeholder: Select the correct chip using a separate CS line (not shown in simple AD9850 setup)
  
  // Send the 32-bit FTW + 8 control bits (5 phase bits, 3 function bits)
  uint32_t dds_word = (ftw << 8) | 0x00; // Phase and control bits are 0 for now
  
  // In a real setup, this function would handle the bit-banging protocol (writeDDS)
  // For now, this placeholder shows the intent.
  Serial.print("DDS "); Serial.print(chip_id); Serial.print(" set to: "); Serial.println(freq_hz);
}

void setPhase(uint8_t phase_step, int chip_id) {
  // The phase step is 0-31 (5 bits)
  // This function needs to generate the new 40-bit control word with the updated phase bits.
  
  // AD9850 phase bits are P0-P4 (bits 37-33 of the 40-bit word)
  // This is highly specific to the AD9850 library/protocol you use.
  
  // Placeholder: In a real library, you would call:
  // AD9850.setPhase(phase_step);
  
  Serial.print("DDS "); Serial.print(chip_id); Serial.print(" Phase Updated to Step: "); Serial.println(phase_step);
}
```
