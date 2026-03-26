# FPGA Matrix Keypad Combination Lock 🔒

This project is a fully functional digital combination lock implemented in Verilog for FPGA development boards. It features a 4x4 matrix keypad interface, mechanical switch debouncing, a robust Finite State Machine (FSM) for core logic, and visual feedback via a multiplexed 7-segment display.

## ✨ Key Features

Matrix Keypad Scanning:** Custom hardware driver to continuously scan a 4x4 matrix keypad
  * RIncludes a two-stage input verification:
  * A standard `Debouncer` module to eliminate mechanical contact bounce
  * A `Keypad_lock` rate-limiter to prevent multiple rapid registrations of a single, prolonged key press
*Advanced FSM Core (`Lock_operation`):
  * Controls the main lock states: `IDLE`, `VERIFY`, `OPEN`, `ERROR`, `SET_PASSWORD`, and `BLOCKED`[cite: 36].
  * Anti-Brute Force:** The system counts failed attempts and completely locks down (moves to `BLOCKED` state) after 4 consecutive wrong passwords
  * Password Management:** Supports changing the password dynamically using a dedicated hardware switch (`set_password`)
* 7-Segment Display Feedback:** Provides clear visual status codes based on the current state:
  * `00FE` - Lock Opened
  * `CD05` - Error (Wrong Password)
  * `5ABE` - Setting New Password mode
  * `8D0C` - System Blocked[cite: 66, 67].
* LED Status: Outputs dedicated signals for direct LED indicators (Closed / Opened)

## 🛠️ Architecture & Modules

The system is modularly designed and connected via the `Top.v` module

1. `Keypad.v`: Scans the 4x4 keypad matrix and maps physical coordinates to 4-bit hex key codes.
2. `Debouncer.v`: Waits for a stable signal (`STABLE_TIME = 500000` clock cycles) to filter out noise.
3. `Keypad_lock.v`**: Enforces a "silence limit" between valid key presses so holding a button doesn't spam the buffer.
4. `Lock_operation.v`: The brain of the project. [cite_start]A Finite State Machine that buffers inputs, verifies the 4-digit code, manages the lock state, and outputs the display data
5. `Seven_seg.v`**: A multiplexed display driver that converts 16-bit hex values into 7-segment cathode signals.

## 🎮 How to Use (Operation Guide)

* Default Password:** The default code on startup is `2208`.
* Inputting the Code: Press exactly four numbers on the keypad.
* Accept Code: Press the `F` key (hex `1111`) on the keypad to submit and verify the code.
* Clear Buffer: Made a mistake? [cite_start]Press the **`C`** key (hex `1100`) to clear your current input and start typing again.
* Setting a New Password: 1. Toggle the `set_password` switch to HIGH.
  2. Enter a new 4-digit code.
  3. [cite_start]Press **`F`** to save the new password. 
  4. Toggle the switch back to LOW.

## 🚀 Getting Started

1. Clone this repository.
2. Import the `.v` source files into your FPGA design suite (e.g., Vivado, Quartus).
3. Create a constraint file (`.xdc` / `.qsf`) mapping the inputs/outputs (clk, reset, switches, keypad rows/columns, 7-seg anodes/cathodes) to your specific board.
4. Synthesize, generate the bitstream, and program your device!
