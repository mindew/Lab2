# Midpoint Check In Test Procedure

To test the behavior of our midpoint module on the FPGA, one can press button 0 to assert parallelLoad and thus load the value of parallelIn into parallelOut. It should then display the hexadecimal value "A5" on the LEDs. We can see the 4 least significant bits as 0101 and then when we press button 1 it will toggle the 4 most significant bits as 1010 on the LEDs.

To test the serial input, we can switch on switch 1 to get a peripheralClkEdge. We can control the value of the serial value we are inputting by switching switch 0 between 0 and 1. We can then see the value of the first LED match the serial input value every time there is a peripheralClkEdge.
