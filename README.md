# System Verilog Click Library 

This library tries to reimplement a library for using phase-decoupled click-based asynchronous components, that was originally implemented in GHDL in the library [Async-Click-Library](https://github.com/zuzkajelcicova/Async-Click-Library). This project now implements it in System Verilog, with interfaces for ease of use.

## Fibonacci circuit
The Fibonacci circuit has been reimplemented from the original library, as a test of this library. To run it just import the source files into a project. The top module is the is called "fib_top.vs" with an accompanying testbench "tb_fib.vs".

This has been tested on a Basys3 FPGA board from diligent, any other board is up to the user to configure.

For information on how to initalize the system refer to [the original library](https://github.com/zuzkajelcicova/Async-Click-Library).