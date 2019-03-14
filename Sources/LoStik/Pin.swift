//
//  PinName.swift
//  LoStik
//
//  Created by Alsey Coleman Miller on 3/14/19.
//

/// Digital Pin
public enum Pin: String {
    
    case gpio0 = "GPIO0"
    case gpio1 = "GPIO1"
    case gpio2 = "GPIO2"
    case gpio3 = "GPIO3"
    case gpio4 = "GPIO4"
    case gpio5 = "GPIO5"
    case gpio6 = "GPIO6"
    case gpio7 = "GPIO7"
    case gpio8 = "GPIO8"
    case gpio9 = "GPIO9"
    case gpio10 = "GPIO10"
    case gpio11 = "GPIO11"
    case gpio12 = "GPIO12"
    case gpio13 = "GPIO13"
    
    case uartCTS = "UART_CTS"
    case uartRTS = "UART_RTS"
    
    case test0 = "TEST0"
    case test1 = "TEST1"
}

public extension Pin {
    
    public enum State: Int {
        
        case off = 0
        case on = 1
    }
}

public extension Pin {
    
    public enum Mode: String {
        
        case digitalOut = "digout"
        case digitalIn = "digin"
        case analog = "ana"
    }
}
