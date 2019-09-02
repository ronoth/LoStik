#!/usr/bin/env python3
import io
import sys
import time
import argparse

import serial
from serial.threaded import LineReader, ReaderThread

class PrintLines(LineReader):
    def connection_made(self, transport):
        super(PrintLines, self).connection_made(transport)
        print("port opened")

    def handle_line(self, data):
        print(data)

    def connection_lost(self, exc):
        print("port closed")

def blink(port, delay, mode):
    ser = serial.Serial(port, baudrate=57600)
    with ReaderThread(ser, PrintLines) as protocol:
        protocol.write_line("sys get ver")
        time.sleep(.5)
        while True:
            if mode == "blue" or mode == "both":
                protocol.write_line("sys set pindig GPIO10 1")
                time.sleep(delay)
            if mode == "red" or mode == "both":
                protocol.write_line("sys set pindig GPIO11 0")
                time.sleep(delay)
            if mode == "blue" or mode == "both":
                protocol.write_line("sys set pindig GPIO10 0")
                time.sleep(delay)
            if mode == "red" or mode == "both":
                protocol.write_line("sys set pindig GPIO11 1")
                time.sleep(delay)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Blink the LEDs.')
    parser.add_argument('port', help="Serial port descriptor")
    parser.add_argument('--mode', '-m', help="red, blue, both", default="both")
    parser.add_argument('--delay', '-d', help="Delay in seconds as a decimal number.", type=float, default=.5)
    args = parser.parse_args()
    blink(args.port, args.delay, args.mode)
