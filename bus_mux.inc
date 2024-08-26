--Copyright (C) 2023  Intel Corporation. All rights reserved.
--Your use of Intel Corporation's design tools, logic functions 
--and other software and tools, and any partner logic 
--functions, and any output files from any of the foregoing 
--(including device programming or simulation files), and any 
--associated documentation or information are expressly subject 
--to the terms and conditions of the Intel Program License 
--Subscription Agreement, the Intel Quartus Prime License Agreement,
--the Intel FPGA IP License Agreement, or other applicable license
--agreement, including, without limitation, that your use is for
--the sole purpose of programming logic devices manufactured by
--Intel and sold by Intel or its authorized distributors.  Please
--refer to the applicable agreement for further details, at
--https://fpgasoftware.intel.com/eula.


FUNCTION bus_mux 
(
	data0x[31..0],
	data10x[31..0],
	data11x[31..0],
	data12x[31..0],
	data13x[31..0],
	data14x[31..0],
	data15x[31..0],
	data16x[31..0],
	data17x[31..0],
	data18x[31..0],
	data19x[31..0],
	data1x[31..0],
	data20x[31..0],
	data21x[31..0],
	data22x[31..0],
	data23x[31..0],
	data24x[31..0],
	data25x[31..0],
	data26x[31..0],
	data27x[31..0],
	data28x[31..0],
	data29x[31..0],
	data2x[31..0],
	data30x[31..0],
	data31x[31..0],
	data3x[31..0],
	data4x[31..0],
	data5x[31..0],
	data6x[31..0],
	data7x[31..0],
	data8x[31..0],
	data9x[31..0],
	sel[4..0]
)

RETURNS (
	result[31..0]
);
