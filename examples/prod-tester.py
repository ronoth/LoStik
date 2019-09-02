import time
import serial
from serial.tools import list_ports
import sys
from blinky import blink
import threading

def test(dev):
    try:
        blink("/dev/%s" % dev, .25, "both")
    except serial.SerialException:
        print("%s disconnected" % dev)

old_devices = set()

def check_new_devices():
    global old_devices
    devices = set([item.name for item in list_ports.comports() if item.vid == 6790 ])
    #import pdb; pdb.set_trace()
    # print devices
    diff = devices - old_devices
    old_devices = devices
    return diff

while True:
    new_devices = check_new_devices()
    if(not new_devices):
        sys.stdout.write(".")
        sys.stdout.flush()
    for dev in new_devices:
        print("Running test on {}".format(dev))
        threading.Thread(target = test, args = (dev,)).start()
    time.sleep(1)
