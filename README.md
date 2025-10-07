
---

## ⚙️ Project 1 – MIPS32 Single-Cycle

A simplified MIPS32 processor that executes each instruction in a single clock cycle.

### 🧩 Features
- Classical **5-stage architecture** (IF, ID, EX, MEM, WB)  
- **Modular VHDL design** with separated components  
- Supports basic MIPS instructions (`lw`, `sw`, `add`, `sub`, `beq`, etc.)  
- Extended instruction set: `bne`, `xor`, `sra`, `ori`  
- **Real-time instruction display** on Basys3 7-segment displays  
- **Button-controlled instruction stepping**

### 🧠 Challenges & Solutions
- **Limited display** → implemented switch-based viewing for full 32-bit instructions  
- **Button bouncing** → solved using a custom debounce module (`MPG.vhd`)  
- **Control signal debugging** → verified register writes and signal propagation step-by-step  

### 🚀 Future Improvements
- Implement **data hazards** and **forwarding**  
- Add **more MIPS instructions**  
- Extend **data memory** for larger programs  

---

## ⚙️ Project 2 – MIPS32 Pipelined

An advanced version implementing **instruction-level parallelism** through pipelining.

### 🧩 Features
- **5-stage pipelined MIPS32 processor** (IF, ID, EX, MEM, WB)  
- Handles **data and control hazards**  
- Added instructions: `bne`, `xor`, `sra`, `ori`  
- **Step-by-step execution** visible on Basys3  
- Fully modular **VHDL structure**, reusable components  

### 🧠 Challenges
- **Structural and data hazards** → resolved with NOP insertion and partial forwarding  
- **Branch delay slot** handling between IF and ID stages  
- **Button synchronization** for slow clock operation  
- **7-segment display formatting** fixed for correct real-time updates  

### 🚀 Future Improvements
- Implement **automatic forwarding** for data hazards  
- Add **branch hazard detection and resolution unit**  
- Extend the instruction set (`lui`, `slti`, `jal`, `mult`, etc.)  
- Add a **graphical interface** for program loading  
- Improve visual debugging with **LCD or detailed 7-segment output**  

---

## 🧰 Tools Used
- **Language:** VHDL  
- **Hardware:** Basys3 FPGA  
- **Software:** Xilinx Vivado  
- **Architecture:** MIPS 32-bit RISC  

---

## 📖 Documentation
Each project includes a full technical document (in Romanian):

- [`DOCUMENTATIE.pdf`](./MIPS_SINGLE_CYCLE/DOCUMENTATIE.pdf) – Single-Cycle version  
- [`DOCUMENTATIA.pdf`](./MIPS_PIPELINE/DOCUMENTATIA.pdf) – Pipelined version  

---

## 👩‍💻 Author
Developed by **Ioana Paucean**  
Faculty of Computer Engineering and Information Technology  
2025

---
