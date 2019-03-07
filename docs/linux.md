# Driver

Most modern Debian distros come with the CH340 serial driver compiled as a kernel module.  WCH offers [Linux driver source](http://www.wch.cn/download/CH341SER_LINUX_ZIP.html), but compilation and installation is not covered here.

# Terminal

There is a python terminal utility located in examples/miniterm.py that is recommended.

Any terminal emulator that can send \r\n should work.  Key settings are:
* baud: 57600
* data bits: 8
* stop bits: 1
* parity: none
* flow control: none

# GUI
Microchip offers a programm called "Lora Dev Utility" that is part of the [LoRa Development Suite](https://www.microchip.com/developmenttools/ProductDetails/dv164140-1)

![](images/lora-dev-utility.png)