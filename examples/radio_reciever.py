#!/usr/bin/env python3
import time
import sys
import serial
import traceback
from serial.threaded import LineReader, ReaderThread

class PrintLines(LineReader):

    def connection_made(self, transport):
        print("connection made")
        self.transport = transport
        time.sleep(.5)
        self.send_cmd('sys get ver')
        time.sleep(.5)
        self.send_cmd('mac pause')
        time.sleep(.5)
        self.send_cmd('radio set pwr 10')
        time.sleep(.5)
        self.send_cmd('radio rx 0')
        time.sleep(.5)
        self.send_cmd("sys set pindig GPIO10 0")

    def handle_line(self, data):
        if data == "ok":
            return
        if data == "radio_err":
            self.send_cmd('radio rx 0')
            return
        
        self.send_cmd("sys set pindig GPIO10 1")
        print(data)
        time.sleep(.1)
        self.send_cmd("sys set pindig GPIO10 0")

    def connection_lost(self, exc):
        if exc:
            print(exc)
        print("port closed")

    def send_cmd(self, cmd):
        self.transport.write(('%s\r\n' % cmd).encode('UTF-8'))

def listen():
    with ReaderThread(ser, PrintLines) as protocol:
        while(1):
            pass

if __name__ == "__main__":
    ser = serial.Serial(sys.argv[1] or PORT, baudrate=57600)
    listen()
