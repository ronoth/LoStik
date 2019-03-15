//
//  RadioCommand.swift
//  LoStik
//
//  Created by Alsey Coleman Miller on 3/14/19.
//

import Foundation

public extension LoStik {
    
    /// LoRaWAN protocol commands.
    var radio: Radio { return Radio(device: self) }
    
    public struct Radio {
        
        internal let device: LoStik
        
        internal init(device: LoStik) {
            self.device = device
        }
    }
}

public extension LoStik.Radio {
    
    /**
     Recieve data.
     
     - Parameter windowSize: Decimal number representing the number of symbols (for LoRa modulation) or time out in milliseconds (for FSK modulation) that the receiver will be opened, from 0 to 65535. Set <rxWindowSize> to ‘0’ in order to enable the Continuous Reception mode. Continuous Reception mode will be exited once a valid packet is received.
     
     - Note: Ensure the radio Watchdog Timer time-out is higher than the Receive window size. The mac pause command must be called before any radio transmission or reception, even if no MAC operations have been initiated before.
     */
    func recieve(windowSize: UInt16 = 0) throws -> Data {
        
        try device.send(command: .radio(.receive(windowSize)))
        var response = try device.read()
        
        /**
         Response after entering the command:
         • ok – if parameter is valid and the transceiver is configured in Receive mode
         • invalid_param – if parameter is not valid
         • busy – if the transceiver is currently busy
        */
        guard response == .ok
            else { throw LoStikError.errorCode(response) }
        
        /**
         Response after the receive process:
         • radio_rx <data> – if reception was successful, <data>: hexadecimal value that was received;
         • radio_err – if reception was not successful, reception time-out occurred
         */
        response = try device.read()
        
        let prefix = "radio_rx "
        
        guard response.rawValue.contains(prefix)
            else { throw LoStikError.errorCode(response) }
        
        let hexadecimalString = response.rawValue.replacingOccurrences(of: prefix, with: "")
        
        guard let data = Data(hexadecimal: hexadecimalString)
            else { throw LoStikError.errorCode(response) }
        
        return data
    }
    
    /**
     Transmit data
     
     - Parameter data: Data to be transmitted, from 0 to 255 bytes for LoRa modulation and from 0 to 64 bytes for FSK modulation.
     */
    func transmit(_ data: Data) throws {
        
        assert(data.count <= 255, "Maximum 255 bytes for LoRa modulation")
        
        try device.send(command: .radio(.transmit(data)))
        var response = try device.read()
        
        /**
         Response after entering the command:
         • ok – if parameter is valid and the transceiver is configured in Transmit mode
         • invalid_param – if parameter is not valid
         • busy – if the transceiver is currently busy
         */
        guard response == .ok
            else { throw LoStikError.errorCode(response) }
        
        /**
         Response after the effective transmission:
         • radio_tx_ok – if transmission was successful
         • radio_err – if transmission was unsuccessful (interrupted by radio Watchdog
         Timer time-out)
         */
        response = try device.read()
        guard response == .transmissionOk
            else { throw LoStikError.errorCode(response) }
    }
}

public extension LoStik.Radio {
    
    public enum Command: Equatable, Hashable {
        
        /// This command configures the radio to receive simple radio packets according to prior configuration settings
        case receive(UInt16)
        
        /// This command configures a simple radio packet transmission according to prior configuration settings.
        case transmit(Data)
    }
}

public extension LoStik.Radio.Command {
    
    var type: CommandType {
        
        switch self {
        case .receive: return .receive
        case .transmit: return .transmit
        }
    }
}

internal extension LoStik.Radio.Command {
    
    var arguments: [String] {
        
        switch self {
        case let .receive(windowSize):
            return ["\(windowSize)"]
        case let .transmit(data):
            return [data.toHexadecimal()]
        }
    }
}

public extension LoStik.Radio.Command {
    
    public enum CommandType: String {
        
        /// This command configures the radio to receive simple radio packets according to prior configuration settings
        case receive = "rx"
        
        /// This command configures a simple radio packet transmission according to prior configuration settings.
        case transmit = "tx"
        
        /// This command will put the module into a Continuous Wave (cw) Transmission for system tuning or certification use.
        case continuousWave = "cw"
        
        /// This command allows modification to the radio setting directly. This command allows for the user to change the method of radio operation within module type band limits.
        case set
        
        /// This command grants the ability to read out radio settings as they are currently configured.
        case get
    }
}
