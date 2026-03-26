# FPGA Matrix Keypad Combination Lock 🔒

This project is a fully functional digital combination lock implemented in **Verilog** for FPGA development boards. It features a 4x4 matrix keypad interface, mechanical switch debouncing, a robust Finite State Machine (FSM) for core logic, and visual feedback via a multiplexed 7-segment display.

## ✨ Key Features

* [cite_start]**Matrix Keypad Scanning:** Custom hardware driver to continuously scan a 4x4 matrix keypad[cite: 1, 2, 3, 4, 5, 6, 7].
* **Robust Input Handling:** Includes a two-stage input verification:
  * [cite_start]A standard `Debouncer` module to eliminate mechanical contact bounce[cite: 106, 107, 108, 109, 110, 111, 112].
  * [cite_start]A `Keypad_lock` rate-limiter to prevent multiple rapid registrations of a single, prolonged key press[cite: 26, 27, 28, 29, 30, 31, 32].
* **Advanced FSM Core (`Lock_operation`):**
  * Controls the main lock states: `IDLE`, `VERIFY`, `OPEN`, `ERROR`, `SET_PASSWORD`, and `BLOCKED`[cite: 36].
  * [cite_start]**Anti-Brute Force:** The system counts failed attempts and completely locks down (moves to `BLOCKED` state) after 4 consecutive wrong passwords[cite: 50, 51].
  * [cite_start]**Password Management:** Supports changing the password dynamically using a dedicated hardware switch (`set_password`)[cite: 34, 41, 42].
* [cite_start]**7-Segment Display Feedback:** Provides clear visual status codes based on the current state:
  * `00FE` - Lock Opened[cite: 63, 64].
  * [cite_start]`CD05` - Error (Wrong Password)[cite: 64, 65].
  * [cite_start]`5ABE` - Setting New Password mode[cite: 65, 66].
  * `8D0C` - System Blocked[cite: 66, 67].
* [cite_start]**LED Status:** Outputs dedicated signals for direct LED indicators (Closed / Opened)[cite: 95, 105].

## 🛠️ Architecture & Modules

[cite_start]The system is modularly designed and connected via the `Top.v` module[cite: 95].

1. [cite_start]**`Keypad.v`**: Scans the 4x4 keypad matrix and maps physical coordinates to 4-bit hex key codes[cite: 1, 9].
2. [cite_start]**`Debouncer.v`**: Waits for a stable signal (`STABLE_TIME = 500000` clock cycles) to filter out noise[cite: 107].
3. [cite_start]**`Keypad_lock.v`**: Enforces a "silence limit" between valid key presses so holding a button doesn't spam the buffer[cite: 27].
4. **`Lock_operation.v`**: The brain of the project. [cite_start]A Finite State Machine that buffers inputs, verifies the 4-digit code, manages the lock state, and outputs the display data[cite: 34, 35, 36].
5. [cite_start]**`Seven_seg.v`**: A multiplexed display driver that converts 16-bit hex values into 7-segment cathode signals[cite: 69, 70, 71, 72, 73, 74, 75, 76, 77, 78].

## 🎮 How to Use (Operation Guide)

* [cite_start]**Default Password:** The default code on startup is `2208`[cite: 35].
* **Inputting the Code:** Press exactly four numbers on the keypad.
* [cite_start]**Accept Code:** Press the **`F`** key (hex `1111`) on the keypad to submit and verify the code[cite: 41].
* **Clear Buffer:** Made a mistake? [cite_start]Press the **`C`** key (hex `1100`) to clear your current input and start typing again[cite: 43, 44, 45].
* **Setting a New Password:** 1. Toggle the `set_password` switch to HIGH.
  2. Enter a new 4-digit code.
  3. [cite_start]Press **`F`** to save the new password[cite: 41, 42]. 
  4. Toggle the switch back to LOW.

## 🚀 Getting Started

1. Clone this repository.
2. Import the `.v` source files into your FPGA design suite (e.g., Vivado, Quartus).
3. Create a constraint file (`.xdc` / `.qsf`) mapping the inputs/outputs (clk, reset, switches, keypad rows/columns, 7-seg anodes/cathodes) to your specific board.
4. Synthesize, generate the bitstream, and program your device!