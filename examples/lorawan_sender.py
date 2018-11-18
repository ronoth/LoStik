#!/usr/bin/env python3
import time
import serial
import sys
import argparse

parser = argparse.ArgumentParser(description='LoRaWan sender.')
parser.add_argument('port', help="Serial port descriptor")
parser.add_argument('--payload', '-p', help="Payload as string.", type=lambda x: int(x,0), default=0xdeadbeef)
parser.add_argument('--appkey', '-a', help="Application key.", type=lambda x: int(x,0), default=None)
parser.add_argument('--deveui', '-d', help="Device unique ID.", type=lambda x: int(x,0), default=None)
parser.add_argument('--appeui', '-u', help="Application unique ID.", type=lambda x: int(x,0), default=None)
args = parser.parse_args()

if args.appkey == None or args.deveui == None or args.appeui == None:
    print("You need to provide appkey, deveui and appeui")
    sys.exit(1)


def send_cmd(cmd):
    ser.write(('%s\r\n' % cmd).encode('UTF-8'))
    print(ser.readline().decode("UTF-8").strip())


with serial.Serial(args.port, 57600, timeout=1) as ser:
    ch = 1

    send_cmd("sys get hweui")
    send_cmd("sys set pindig GPIO11 1")
    send_cmd('sys get ver')
    send_cmd('radio get mod')
    send_cmd('radio get freq')
    send_cmd('radio get sf')
    send_cmd('mac pause')
    send_cmd('mac resume')
    send_cmd('mac reset 868')

    print('devui %.16x' % int(args.deveui))
    print('appeui %.16x' % int(args.appeui))
    print('appkey %x' % int(args.appkey))
    print('payload %x' % int(args.payload))

    time.sleep(1)

    # can be same as hweui
    send_cmd('mac set deveui %.16x' % int(args.deveui))
    # from the ttn web interface
    send_cmd('mac set appeui %.16x' % int(args.appeui))
    # appkey from ttn web interface
    send_cmd('mac set appkey %x' % int(args.appkey))

    send_cmd("sys set pindig GPIO11 0")

    # now join the network
    print('join now')
    send_cmd('mac join otaa')
    print('start sending in 15 seconds')
    time.sleep(15)

    while True:
        send_cmd('mac tx uncnf %d %x' % (int(ch), int(args.payload)))
        ch = (ch + 1) % 224
        print('new channel %d' % ch)
        time.sleep(2)
