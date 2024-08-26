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


FUNCTION reg_decoder 
(
	data[4..0],
	enable
)

RETURNS (
	eq0,
	eq1,
	eq10,
	eq11,
	eq12,
	eq13,
	eq14,
	eq15,
	eq16,
	eq17,
	eq18,
	eq19,
	eq2,
	eq20,
	eq21,
	eq22,
	eq23,
	eq24,
	eq25,
	eq26,
	eq27,
	eq28,
	eq29,
	eq3,
	eq30,
	eq31,
	eq4,
	eq5,
	eq6,
	eq7,
	eq8,
	eq9
);
