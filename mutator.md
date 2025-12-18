"Mutator" circuit.

	To build a hardware emulator of a Tantalum Oxide memristor, you are essentially building an analog computer that solves the math equations found in Professor Mladenov's LTSpice model.

The most common way to do this on a breadboard is using a "Mutator" circuit. It uses Op-Amps to track the "state" (memory) and a Multiplier to change the resistance.
1. The Shopping List (Components)

You can find these at electronics hobby stores like Mouser, DigiKey, or even Amazon.

    2x Op-Amps: The TL082 or LM358 are perfect for beginners.

    1x Analog Multiplier: The AD633 is the industry standard for this. It "multiplies" the input voltage by the state variable.

    1x Capacitor (10nF to 100nF): This acts as the "memory" by holding a charge that represents the state variable x.

    Resistors: A variety pack (specifically 1kΩ, 10kΩ, and 100kΩ).

    Power Supply: You will need a Dual Rail Power Supply (providing +15V, −15V, and Ground).

2. The Circuit Block Diagram

A memristor emulator is built in three stages:

    The Current Sensor: A small resistor senses how much current is flowing into the "memristor."

    The Integrator (The Memory): An Op-Amp and a Capacitor take that current and "add it up" over time. This creates the state variable voltage (Vx​).

    The Multiplier (The Variable Resistor): This chip takes the original input voltage and multiplies it by the state variable (Vx​). This forces the circuit to act like a resistor that changes its value based on the capacitor's charge.

3. Step-by-Step Breadboard Build
Step A: Create the Integrator (The Brain)

    Connect the input signal to an Op-Amp configured as an Integrator.

    Place the Capacitor in the feedback loop (between the output and the inverting input).

    The output voltage of this Op-Amp is now your State Variable. If current flows in, the voltage goes up; if current flows out, it goes down.

Step B: Setup the Multiplier

    The AD633 has two main inputs. Feed your Input Voltage into one and your State Variable Voltage into the other.

    The output of this chip is now a signal that "knows" both the current time and the past history.

Step C: The Feedback Loop

    Use a final Op-Amp to convert the multiplier's output back into a current. This creates the "Two-Terminal" behavior where the device looks like a single component to the rest of your circuit.

4. How to Test It

Once built, you need to see if it works.

    Input: Hook up a Function Generator to the input and send a Sine Wave (around 100Hz to 1kHz).

    Measurement: Use an Oscilloscope in X-Y Mode.

        Connect Channel 1 to the Voltage.

        Connect Channel 2 to the Current.

    The Goal: You should see a Pinched Hysteresis Loop (the "figure-8" shape). If you see a straight line, it's just a resistor. If you see a circle, it's a capacitor. If you see the "8," you’ve successfully built a memristor!

Would you like me to find a specific wiring pinout for the AD633 multiplier to help you get the connections right on your breadboard?


