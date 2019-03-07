# CH340G Driver

Mac OS X requires the installation of the CH340 USB to Serial Driver.  Please refer to the following repository for installation instructions:

https://github.com/adrianmihalko/ch340g-ch34g-ch34x-mac-os-x-driver

# Terminals

There is a python terminal utility located in examples/miniterm.py that is recommended.  The `screen` commandline utility will also work.  The serial device will be mounted to in the dev directory and appear as `tty.wchusbserial14210` or similar.  

Any terminal emulator that can send \r\n should work.  Key settings are:
* baud: 57600
* data bits: 8
* stop bits: 1
* parity: none
* flow control: none

# GUI
Microchip offers a programm called "Lora Dev Utility" that is part of the [LoRa Development Suite](https://www.microchip.com/developmenttools/ProductDetails/dv164140-1)

![](images/lora-dev-utility.png)