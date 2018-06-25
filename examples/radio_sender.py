#!/usr/bin/env python3
import time
import serial
import sys
import argparse

parser = argparse.ArgumentParser(description='LoRa Radio mode sender.')
parser.add_argument('port', help="Serial port descriptor")
args = parser.parse_args()

def send_cmd(cmd):
    ser.write(('%s\r\n' % cmd).encode('UTF-8'))
    print(ser.readline().decode("UTF-8").strip())

with serial.Serial(args['port'], 57600, timeout=1) as ser:
    send_cmd("sys set pindig GPIO11 0")
    send_cmd('sys get ver')
    send_cmd('radio get mod')
    send_cmd('radio get freq')
    send_cmd('radio get sf')
    send_cmd('mac pause')
    send_cmd('radio set pwr 10')
    send_cmd("sys set pindig GPIO11 0")

    while True:
        time.sleep(2)
        send_cmd("sys set pindig GPIO11 1")
        send_cmd('radio tx %d' % int(time.time()))
        time.sleep(.1)
        send_cmd("sys set pindig GPIO11 0")