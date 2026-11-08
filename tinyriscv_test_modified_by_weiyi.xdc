# ZedBoard XDC for tinyriscv_soc_top (modified by weiyi)
# Top ports:
#   input  clk
#   input  rst
#   output over
#   output succ
#   input  uart_debug_pin
#   output uart_tx_pin
#   input  uart_rx_pin
#   inout  [1:0] gpio

# ------------------------------------------------------------
# Clock: ZedBoard PL 100 MHz oscillator
# ------------------------------------------------------------
set_property PACKAGE_PIN Y9 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
create_clock -name sys_clk -period 10.000 -waveform {0.000 5.000} [get_ports {clk}]


# Generated clock from clk_div2 register
create_generated_clock -name sys_clk_div2 \
    -source [get_ports {clk}] \
    -divide_by 2 \
    [get_pins {clk_div2_reg/Q}]
	
	
# ------------------------------------------------------------
# Reset: BTNC
# Bank 34 on ZedBoard master XDC defaults to LVCMOS25
# ------------------------------------------------------------
set_property PACKAGE_PIN P16 [get_ports {rst}]
set_property IOSTANDARD LVCMOS25 [get_ports {rst}]

# ------------------------------------------------------------
# Status outputs
# over  -> LD0
# succ  -> LD1
# ------------------------------------------------------------
set_property PACKAGE_PIN T22 [get_ports {over}]
set_property IOSTANDARD LVCMOS33 [get_ports {over}]

set_property PACKAGE_PIN T21 [get_ports {succ}]
set_property IOSTANDARD LVCMOS33 [get_ports {succ}]

# ------------------------------------------------------------
# UART debug enable
# Use SW0 as a manual enable switch
# Bank 35 default on master XDC is LVCMOS25
# ------------------------------------------------------------
set_property PACKAGE_PIN F22 [get_ports {uart_debug_pin}]
set_property IOSTANDARD LVCMOS25 [get_ports {uart_debug_pin}]

# ------------------------------------------------------------
# UART TX/RX
# ZedBoard onboard USB-UART is PS MIO, not PL IO
# So map UART to PL Pmod JA
# ------------------------------------------------------------
set_property PACKAGE_PIN Y11 [get_ports {uart_tx_pin}]
set_property IOSTANDARD LVCMOS33 [get_ports {uart_tx_pin}]

set_property PACKAGE_PIN AA11 [get_ports {uart_rx_pin}]
set_property IOSTANDARD LVCMOS33 [get_ports {uart_rx_pin}]

# ------------------------------------------------------------
# GPIO[1:0]
# Put them on nearby JA pins
# ------------------------------------------------------------
set_property PACKAGE_PIN Y10 [get_ports {gpio[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[0]}]

set_property PACKAGE_PIN AA9 [get_ports {gpio[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[1]}]