# Basys 3 Hardware Repository

This repository contains Vivado projects for all demos for the Basys 3.

For more information about the Basys 3, visit its [Resource Center](https://reference.digilentinc.com/reference/programmable-logic/basys-3/start) on the Digilent Wiki.

Each demo contained in this repository is documented on the Digilent Wiki, links in the table below.

| Wiki Link | Description |
|-----------|-------------|
| [Basys 3 Abacus Demo](https://reference.digilentinc.com/reference/programmable-logic/basys-3/demos/abacus) |  The Abacus demo can perform one of four arithmetic functions on two 8-bit numbers  |
| [Basys 3 General I/O Demo](https://reference.digilentinc.com/reference/programmable-logic/basys-3/demos/gpio) |  This demo uses the Basys 3's switches, LEDs, pushbuttons, seven-segment display, VGA connector, USB HID Host port and USB UART bridge  |
| [Basys 3 Keyboard Demo](https://reference.digilentinc.com/reference/programmable-logic/basys-3/demos/keyboard) |  When a keyboard button is pressed/released, the value of the scan code will be converted to ASCII and transmitted to the terminal |
| [Basys 3 XADC Analog to Digital Converter Demo](https://reference.digilentinc.com/reference/programmable-logic/basys-3/demos/xadc) |   The 7-Segment display shows the current voltage across the selected XADC pins and the LEDs turn on from right to left as the input voltage increases. |

## Repository Description

This repository contains the Vivado projects and hardware designs for all of the demos that we provide for the Basys 3. As some demos also require software sources contained in Vitis workspaces, this repository should not be used directly. The [Basys 3](https://github.com/Digilent/Basys-3) repository contains all sources for these demos across all tools, and pulls in all of this repository's sources by using it as a submodule.

For instructions on how to use this repository with git, and for additional documentation on the submodule and branch structures used, please visit [Digilent FPGA Demo Git Repositories](https://reference.digilentinc.com/reference/programmable-logic/documents/git) on the Digilent Wiki. Note that use of git is not required to use this demo. Digilent recommends the use of project releases, for which instructions can be found in each demo wiki page, linked in the table of demos, above.

Demos were moved into this repository during 2020.1 updates. History of these demos prior to these updates can be found in their old repositories, linked below:
* https://github.com/Digilent/Basys-3-Abacus
* https://github.com/Digilent/Basys-3-GPIO
* https://github.com/Digilent/Basys-3-Keyboard
* https://github.com/Digilent/Basys-3-XADC
