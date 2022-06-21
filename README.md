# FPGA-based-UART-communication
This project includes the full duplex UART communication based on a Xilinx Z7020 SoC - UART application developed in SDK.
The system is developed on Zedboard and deployed in a Free Space Optical (LASER) communication system. 
This project also includes a selection logic block that selects between two modes of communication (data or voice in our case) and also generates particular signatures for both modes - selection block and selection block rx.
The last part of this project is the selection between UART tx and rx channels implemented using an AXI GPIO IP and additional logic - Tx Rx selection.
