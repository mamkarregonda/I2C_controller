# I2C Protocol Implementation in Verilog

This repository provides a complete Verilog implementation of the **I2C (Inter-Integrated Circuit)** protocol, featuring both **master (controller)** and **slave** modules, along with a **testbench** for simulation and verification.

## 📚 Overview

I2C is a widely used serial communication protocol that enables data transfer between microcontrollers and peripherals using just two bidirectional lines: **SDA (Serial Data)** and **SCL (Serial Clock)**.

This project includes:

- I2C Master controller supporting both read and write operations.
- I2C Slave controller responding to a specified 7-bit address.
- Clock division and signal timing logic.
- Functional testbench with waveform generation.
- Sample simulation output for visualization.

---

## 🧱 Modules Description

### 🔹 `i2c_controller` (Master)

| Signal      | Direction | Description                    |
|-------------|-----------|--------------------------------|
| `clk`       | Input     | System clock                   |
| `rst`       | Input     | Asynchronous reset             |
| `addr[6:0]` | Input     | 7-bit slave address            |
| `data_in`   | Input     | 8-bit data to be sent          |
| `enable`    | Input     | Start signal for transmission  |
| `rw`        | Input     | Read (1) / Write (0) control   |
| `data_out`  | Output    | Data received from slave       |
| `ready`     | Output    | High when master is idle       |
| `i2c_sda`   | Inout     | I2C Serial Data line           |
| `i2c_scl`   | Inout     | I2C Serial Clock line          |

#### Features
- Generates **START** and **STOP** conditions.
- Sends **7-bit address + RW** bit.
- Handles data **transmit and receive** cycles.
- Manages **ACK/NACK** responses.
- Clock divider for adjustable I2C frequency.

---

### 🔹 `i2c_slave_controller` (Slave)

| Signal    | Direction | Description                     |
|-----------|-----------|---------------------------------|
| `i2c_sda` | Inout     | I2C Serial Data line            |
| `i2c_scl` | Inout     | I2C Serial Clock line           |

#### Features
- Responds to a **fixed 7-bit address** (`0101010`).
- Handles both **read and write** cycles.
- Sends ACK and data as required.
- Echoes received data back to master for read verification.

---

## ▶️ Simulation Setup

### 🔧 Requirements

- [Icarus Verilog](http://iverilog.icarus.com/)
- [GTKWave](http://gtkwave.sourceforge.net/)

### 🏃 Run the Simulation

```bash
# Compile the design
iverilog -o main tb.v

# Run the simulation
vvp main

# Open waveform in GTKWave
gtkwave my_design.vcd
```

## 🧪 Testbench Scenarios
The i2c_controller_tb module validates both write and read operations between the master and slave.

## ✅ Write Operation
Master sends the slave address 0x2A with write bit (rw = 0)

Data 0xFF is transmitted to the slave.

Slave acknowledges and stores the received data.

## ✅ Read Operation
Master sends the slave address 0x2A with read bit (rw = 1)

Slave echoes back the data (0xFF) previously written.

Master reads and stores the received byte.

## ⏱️ Timing Summary
Internal clock divider (DIVIDE_BY = 4) generates I2C-compliant clocking.

Simulation runs with #delay statements and continuous clock toggling.

## 👤 Author
Name: Mamkar Regonda
GitHub: mamkaregonda
Linkedin: mamkar-regonda
Location: Hyderabad
