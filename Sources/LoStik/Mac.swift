//
//  MacCommand.swift
//  LoStik
//
//  Created by Alsey Coleman Miller on 3/14/19.
//

import Foundation

public extension LoStik {
    
    /// LoRaWAN protocol commands.
    var mac: Mac { return Mac(device: self) }
    
    public struct Mac {
        
        internal let device: LoStik
        
        internal init(device: LoStik) {
            self.device = device
        }
    }
}

public extension LoStik.Mac {
    
    /**
     This command will automatically reset the software LoRaWAN stack and initialize it with the parameters for the selected band.
     
     - Note: This command will set default values for most of the LoRaWAN parameters. Everything set prior to this command will lose its set value, being reinitialized to the default value, including setting the cryptographic keys to 0.
     */
    public func reset() throws {
        
        try device.send(command: .mac(.reset))
        let response = try device.read()
        
        guard response == .ok
            else { throw LoStikError.errorCode(response) }
    }
    
    /**
     The network can issue a certain command (Duty Cycle Request frame with parameter 255) that would require the RN2903 module to go silent immediately. This mechanism disables any further communication of the module, effectively isolating it from the network. Using mac force enable, after this network command has been received, restores the module’s connectivity by allowing it to send data.
     */
    public func forceEnable() throws {
        
        try device.send(command: .mac(.forceEnable))
        let response = try device.read()
        
        guard response == .ok
            else { throw LoStikError.errorCode(response) }
    }
    
    /**
     This command pauses the LoRaWAN stack functionality to allow transceiver (radio) configuration.
     
     - Returns: 0–4294967295 (decimal number epresenting the number of milliseconds the mac can be paused)
     
     - Note: If already joined to a network, this command MUST be called BEFORE configuring the radio parameters, initiating radio reception, or transmission.
     */
    @discardableResult
    public func pause() throws -> UInt {
        
        try device.send(command: .mac(.pause))
        let response = try device.read()
        
        guard let miliseconds = UInt(response.rawValue)
            else { throw LoStikError.errorCode(response) }
        
        return miliseconds
    }
    
    /**
     This command resumes LoRaWAN stack functionality, in order to continue normal functionality after being paused.
     
     - Note: This command MUST be called AFTER all radio commands have been issued and all the corresponding asynchronous messages have been replied.
     */
    public func resume() throws {
        
        try device.send(command: .mac(.resume))
        let response = try device.read()
        
        guard response == .ok
            else { throw LoStikError.errorCode(response) }
    }
}

public extension LoStik.Mac {
    
    /// LoRaWAN protocol commands.
    public enum Command: Equatable, Hashable {
        
        /**
         This command will automatically reset the software LoRaWAN stack and initialize it with the parameters for the selected band.
         
         - Note: This command will set default values for most of the LoRaWAN parameters. Everything set prior to this command will lose its set value, being reinitialized to the default value, including setting the cryptographic keys to 0.
         */
        case reset
        
        /**
         Transmit data
        */
        case send(UplinkPayloadType, Port, Data)
        
        /**
         The network can issue a certain command (Duty Cycle Request frame with parameter 255) that would require the RN2903 module to go silent immediately. This mechanism disables any further communication of the module, effectively isolating it from the network.Using mac force enable,after this network command has bee nreceived, restores the module’s connectivity by allowing it to send data.
         */
        case forceEnable
        
        /**
         This command pauses the LoRaWAN stack functionality to allow transceiver (radio) configuration.
         
         - Note: If already joined to a network, this command MUST be called BEFORE configuring the radio parameters, initiating radio reception, or transmission.
         */
        case pause
        
        /**
         This command resumes LoRaWAN stack functionality, in order to continue normal functionality after being paused.
         
         - Note: This command MUST be called AFTER all radio commands have been issued and all the corresponding asynchronous messages have been replied.
         */
        case resume
    }
}

/// Uplink payload type
public extension LoStik.Mac {
    
    /// Uplink payload type
    public enum UplinkPayloadType: String {
        
        case confirmed = "cnf"
        case unconfirmed = "uncnf"
    }
}

public extension LoStik.Mac {
    
    public struct Port: Equatable, Hashable, RawRepresentable {
        
        public let rawValue: UInt8
        
        public init?(rawValue: UInt8) {
            
            guard rawValue <= Port.max.rawValue,
                rawValue >= Port.min.rawValue
                else { return nil }
            
            self.rawValue = rawValue
        }
        
        private init(_ unsafe: UInt8) {
            
            self.rawValue = unsafe
        }
    }
}

public extension LoStik.Mac.Port {
    
    static let min: LoStik.Mac.Port = LoStik.Mac.Port(1)
    
    static let max: LoStik.Mac.Port = LoStik.Mac.Port(223)
}

extension LoStik.Mac.Port: CustomStringConvertible {
    
    public var description: String {
        
        return rawValue.description
    }
}

public extension LoStik.Mac.Command {
    
    var type: CommandType {
        
        switch self {
        case .reset: return .reset
        case .send: return .send
        case .forceEnable: return .forceEnable
        case .pause: return .pause
        case .resume: return .resume
        }
    }
}

internal extension LoStik.Mac.Command {
    
    var arguments: [String] {
        
        switch self {
        case let .send(type, port, data):
            return [type.rawValue, port.description, data.toHexadecimal()]
        case .reset,
             .forceEnable,
             .pause,
             .resume:
            return []
        }
    }
}

public extension LoStik.Mac.Command {
    
    public enum CommandType: String {
        
        /// Resets the module and sets default values for most of the LoRaWAN parameters.
        case reset
        
        /// Sends the data string on a specified port number.
        case send = "tx"
        
        /// Informs the module to join the configured network.
        case join
        
        /// Saves LoRaWAN configuration parameters to the user EEPROM.
        case save
        
        /// Enabled the module after LoRaWAN network server commanded the end device to become silent immdiately.
        case forceEnable = "forceENABLE"
        
        /// Pauses LoRaWAN stack functionality to allow transceiver (radio) configuration.
        case pause
        
        /// Restores the LoRaWAN stack functionality.
        case resume
        
        /// Accesses and modifies specific MAC related parameters.
        case set
        
        /// Reads back current MAC related parameters from the module.
        case get
    }
}
