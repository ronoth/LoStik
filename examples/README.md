# Examples

Python examples require Python 3.  Be sure to install the dependiencies in requirements.txt

    pip install -r requirements.txt

## Miniterm

miniterm.py is a light weight terminal emulator that works well with LoRa stick. 
The RN2903/R2483 radios require \r\n line ending and run at 57600 baud.

    ./miniterm.py --echo /dev/ttyUSB0 57600

## Blinky

blinky.py is for testing the user LEDs on the LoRa Stik.  There is a red led tied to GPIO11 and a blue led tied to GPIO10. 

    ./blinky.py  -m blue -d 1 /dev/ttyUSB0

will blink the blue led once per second

    ./blinky.py -m both -d .5 /dev/ttyUSB0

will alternate the blue and red leds every .5 seconds.

## Packet Radio

radio_reciever.py and radio_sender.py are used for sending LoRa packets between two LoRa Stiks without the need for a LoRaWAN gateway.  The included example sends a unix timestamp packet every 2 seconds and the reciever prints the incoming packets to stdout.

## LoRaWAN

