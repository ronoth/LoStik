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
}

public extension LoStik.Mac {
    
    /// LoRaWAN protocol commands.
    public enum Command: Equatable, Hashable {
        
        case reset
        case send(UplinkPayloadType, Port, Data)
        //case join
        //case save
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
        }
    }
}

internal extension LoStik.Mac.Command {
    
    var arguments: [String] {
        
        switch self {
        case let .send(type, port, data):
            return [type.rawValue, port.description, data.toHexadecimal()]
        case .reset:
            return []
        }
    }
}

public extension LoStik.Mac.Command {
    
    public enum CommandType: String {
        
        /// Resets the RN2903 module and sets default values for most of the LoRaWAN parameters.
        case reset
        
        /// Sends the data string on a specified port number.
        case send = "tx"
    }
}
