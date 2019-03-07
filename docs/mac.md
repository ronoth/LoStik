# CH340G Driver

Mac OS X requires the installation of the CH340 USB to Serial Driver.  Please refer to the following repository for installation instructions:

https://github.com/adrianmihalko/ch340g-ch34g-ch34x-mac-os-x-driver

# Terminals

Any terminal emulator that supports ending \<CR>\<LF> characters following a command will work.  There is a python terminal utility located in examples/miniterm.py that is recommended.  The `screen` commandline utility will also work.  The serial device will be mounted to in the dev directory and appear as `tty.wchusbserial14210` or similar.  LoStik is 57600 buad.