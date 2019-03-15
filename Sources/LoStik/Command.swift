//
//  CommandType.swift
//  LoStik
//
//  Created by Alsey Coleman Miller on 3/14/19.
//

/// LoStik Command
public enum Command: Equatable, Hashable {
    
    /**
     Issues system level behavior actions, gathers status information on the firmware and hardware version, or accesses the module user EEPROM memory.
     */
    case system(LoStik.System.Command)
    
    /**
     Issues LoRaWAN protocol network communication behaviors, actions and configurations commands.
     */
    case mac(LoStik.Mac.Command)
    
    /**
     Issues radio specific configurations, directly accessing and updating the transceiver setup.
     */
    case radio(LoStik.Radio.Command)
}

public extension Command {
    
    var type: CommandType {
        
        switch self {
        case .system: return .system
        case .mac: return .mac
        case .radio: return .radio
        }
    }
}

internal extension Command {
    
    var arguments: [String] {
        
        switch self {
        case let .system(command): return [command.type.rawValue] + command.arguments
        case let .mac(command): return [command.type.rawValue] + command.arguments
        case let .radio(command): return [command.type.rawValue] + command.arguments
        }
    }
}

extension Command: CustomStringConvertible {
    
    public var description: String {
        
        let components = [type.rawValue] + arguments
        
        return components.reduce("", { $0 + ($0.isEmpty ? "" : " ") + $1 })
    }
}

// MARK: - Supporting Types

public enum CommandType: String {
    
    /**
     Issues system level behavior actions, gathers status information on the firmware and hardware version, or accesses the module user EEPROM memory.
     */
    case system = "sys"
    
    /**
     Issues LoRaWAN protocol network communication behaviors, actions and configurations commands.
     */
    case mac = "mac"
    
    /**
     Issues radio specific configurations, directly accessing and updating the transceiver setup.
     */
    case radio = "radio"
}
