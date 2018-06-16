import serial
from serial.threaded import LineReader, ReaderThread
import io
import sys
import time

delay = .1

class PrintLines(LineReader):
    def connection_made(self, transport):
        super(PrintLines, self).connection_made(transport)
        print("port opened")

    def handle_line(self, data):
        print(data)

    def connection_lost(self, exc):
        print("port closed")

def blink(ser, mode, delay):
    with ReaderThread(ser, PrintLines) as protocol:
        protocol.write_line("sys get ver")
        time.sleep(.5)
        # import pdb; pdb.set_trace()
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
    ser = serial.Serial(sys.argv[1], baudrate=57600)
    blink(ser, sys.argv[2], float(sys.argv[3]))