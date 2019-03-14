//
//  SystemCommand.swift
//  LoStik
//
//  Created by Alsey Coleman Miller on 3/14/19.
//

public extension LoStik {
    
    func getVersion() throws -> Version {
        
        try send(command: .system(.get(.version)))
        let response = try read()
        
        print(response)
        
        guard let version = Version(rawValue: response)
            else { throw LoStikError.invalidParameters }
        
        return version
    }
}

public enum SystemCommand: Equatable, Hashable {
    
    /**
     This command puts the system to Sleep for the specified number of milliseconds. The module can be forced to exit from Sleep by sending a break condition followed by a 0x55 character at the new baud rate.
    */
    case sleep(UInt)
    
    /**
     This command resets and restarts the RN2903 module; stored internal configurations will be loaded automatically upon reboot.
    */
    case reset
    
    /**
     This command deletes the current RN2903 module application firmware and prepares it for firmware upgrade. The RN2903 module bootloader is ready to receive new firmware.
     */
    case eraseFirmware
    
    /**
     This command resets the module’s configuration data and user EEPROM to factory default values and restarts the module. After factoryRESET, the RN2903 module will automatically reset and all configuration parameters are restored to factory default values.
     */
    case factoryReset
    
    /// System set commands
    case set(SystemSetCommand)
    
    /// System get commands
    case get(SystemGetCommand)
}

public extension SystemCommand {
    
    var type: SystemCommandType {
        
        switch self {
        case .sleep: return .sleep
        case .reset: return .reset
        case .eraseFirmware: return .eraseFirmware
        case .factoryReset: return .factoryReset
        case .set: return .set
        case .get: return .get
        }
    }
}

internal extension SystemCommand {
    
    var arguments: [String] {
        
        switch self {
        case let .sleep(duration):
            return ["\(duration)"]
        case let .set(command):
            return [command.type.rawValue] + command.arguments
        case let .get(command):
            return [command.type.rawValue] + command.arguments
        case .reset,
             .eraseFirmware,
             .factoryReset:
            return []
        }
    }
}

public enum SystemSetCommand: Equatable, Hashable {
    
    /**
     This command allows the user to modify the user EEPROM at <address> with the value supplied by <data>. Both <address> and <data> must be entered as hex values. The user EEPROM memory is located inside the MCU on the module.
     
     Example:
     
     ```
     sys set nvm 300 A5 // Stores the value 0xA5 at user EEPROM address 0x300.
     ```
     */
    case rom(EEPROMAddress, UInt8)
    
    /**
     This command allows the user to modify the unused pins available for use by the module. The selected <pinname> is driven high or low depending on the desired <pinstate>
     */
    case digitalPin(Pin, Pin.State)
    
    /**
     module and set them as digital output, digital input or analog.
     */
    case pinMode(Pin, Pin.Mode)
}

public extension SystemSetCommand {
    
    var type: SystemSetCommandType {
        
        switch self {
        case .rom: return .rom
        case .digitalPin: return .digitalPin
        case .pinMode: return .pinMode
        }
    }
}

internal extension SystemSetCommand {
    
    var arguments: [String] {
        
        switch self {
        case let .rom(address, data):
            return [address.description, data.toHexadecimal()]
        case let .digitalPin(pin, state):
            return [pin.rawValue, "\(state.rawValue)"]
        case let .pinMode(pin, mode):
            return [pin.rawValue, mode.rawValue]
        }
    }
}

public enum SystemGetCommand: Equatable, Hashable {
    
    /// Returns the information on hardware platform, firmware version, release date.
    case version
    
    /// Returns data from the requested user EEPROM <address>.
    case rom(EEPROMAddress)
    
    /// Returns measured voltage in mV.
    case voltage
    
    /// Returns the preprogrammed EUI node address.
    case identifier
    
    /// Returns the state of the pin, either low (‘0’) or high (‘1’).
    case digitalPin(Pin)
    
    /// This command returns a 10-bit analog value for the queried pin,
    /// where 0 represents 0V and 1023 represents VDD.
    /// An ADC conversion on the VDD pin can be performed by using the command `sys get vdd`.
    case analogPin(Pin)
}

public extension SystemGetCommand {
    
    var type: SystemGetCommandType {
        
        switch self {
        case .version: return .version
        case .rom: return .rom
        case .voltage: return .voltage
        case .identifier: return .identifier
        case .digitalPin: return .digitalPin
        case .analogPin: return .analogPin
        }
    }
}

internal extension SystemGetCommand {
    
    var arguments: [String] {
        
        switch self {
        case let .rom(address):
            return [address.description]
        case let .digitalPin(pin):
            return [pin.rawValue]
        case let .analogPin(pin):
            return [pin.rawValue]
        case .version,
             .voltage,
             .identifier:
            return []
        }
    }
}

public enum SystemCommandType: String {
    
    /// Puts the system in Sleep for a finite number of milliseconds.
    case sleep
    
    /// Resets and restarts the RN2903 module.
    case reset
    
    /// Deletes the current RN2903 module application firmware and prepares it for firmware upgrade.
    /// The RN2903 module bootloader is ready to receive new firmware.
    case eraseFirmware = "eraseFW"
    
    /// Resets the RN2903 module’s configuration data and user EEPROM to factory default values and restarts the RN2903 module.
    case factoryReset = "factoryRESET"
    
    /// Sets specified system parameter values.
    case set
    
    /// Gets specified system parameter values.
    case get
}

public enum SystemSetCommandType: String {
    
    /// Stores <data> to a location <address> of user EEPROM.
    case rom = "nvm"
    
    /// Allows user to set and clear available digital pins.
    case digitalPin = "pindig"
    
    /// Allows the user to set the state of the pins as digital output, digital input or analog.
    case pinMode = "pinmode"
}

public enum SystemGetCommandType: String {
    
    /**
     This command returns the information related to the hardware platform, firmware version, release date and time-stamp on firmware creation.
     */
    case version = "ver"
    
    /// Returns data from the requested user EEPROM <address>.
    case rom = "nvm"
    
    /// Returns measured voltage in mV.
    case voltage = "vdd"
    
    /// Returns the preprogrammed EUI node address.
    case identifier = "hweui"
    
    /// Returns the state of the pin, either low (‘0’) or high (‘1’).
    case digitalPin = "pindig"
    
    /// This command returns a 10-bit analog value for the queried pin, where 0 represents 0V and 1023 represents VDD. An ADC conversion on the VDD pin can be performed by using the command sys get vdd.
    case analogPin = "pinana"
}
