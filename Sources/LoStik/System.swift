//
//  SystemCommand.swift
//  LoStik
//
//  Created by Alsey Coleman Miller on 3/14/19.
//

public extension LoStik {
    
    /// System view of the LoStik.
    var system: System { return System(device: self) }
    
    public struct System {
        
        internal let device: LoStik
        
        internal init(device: LoStik) {
            self.device = device
        }
    }
}

public extension LoStik.System {
    
    /// This command puts the system to Sleep for the specified number of milliseconds.
    func sleep(_ miliseconds: UInt) throws {
        
        try device.send(command: .system(.sleep(miliseconds)))
        let response = try device.read()
        
        guard response == .ok
            else { throw LoStikError.errorCode(response) }
    }
    
    /**
     This command resets and restarts the module; stored internal configurations will be loaded automatically upon reboot.
     */
    func reset() throws -> Version {
        
        try device.send(command: .system(.reset))
        let response = try device.read()
        
        guard let version = Version(rawValue: response.rawValue)
            else { throw LoStikError.errorCode(response) }
        
        return version
    }
    
    /**
     This command deletes the current module application firmware and prepares it for firmware upgrade. the module bootloader is ready to receive new firmware.
     */
    func eraseFirmware() throws {
        
        try device.send(command: .system(.eraseFirmware)) // Response: no response
    }
    
    /**
     This command resets the module’s configuration data and user EEPROM to factory default values and restarts the module. After factory reset,the module will automatically reset and all configuration parameters are restored to factory default values.
     */
    func factoryReset() throws -> Version {
        
        try device.send(command: .system(.factoryReset))
        let response = try device.read()
        
        guard let version = Version(rawValue: response.rawValue)
            else { throw LoStikError.errorCode(response) }
        
        return version
    }
}

public extension LoStik.System {
    
    /**
     This command allows the user to modify the user EEPROM at `address` with the value supplied by `data`.
     The user EEPROM memory is located inside the MCU on the module.
     */
    func setRom(_ data: UInt8, at address: EEPROMAddress) throws {
        
        try device.send(command: .system(.set(.rom(address, data))))
        let response = try device.read()
        
        guard response == .ok
            else { throw LoStikError.errorCode(response) }
    }
    
    /**
     This command allows the user to modify the unused pins available for use by the module. The selected `pin` is driven high or low depending on the desired `state`.
     */
    func setPin(_ pin: Pin, state: Pin.State) throws {
        
        try device.send(command: .system(.set(.digitalPin(pin, state))))
        let response = try device.read()
        
        guard response == .ok
            else { throw LoStikError.errorCode(response) }
    }
    
    /**
     This command allows the user to modify the unused pins availible for use by the module and set them as digital output, digital input or analog.
     
     - Note: Only the GPIO0-3, GPIO5-GPIO13 pins can be configured as analog pins.
     */
    func setPin(_ pin: Pin, mode: Pin.Mode) throws {
        
        try device.send(command: .system(.set(.pinMode(pin, mode))))
        let response = try device.read()
        
        guard response == .ok
            else { throw LoStikError.errorCode(response) }
    }
}

public extension LoStik.System {
    
    /**
     This command returns the information related to the hardware platform, firmware version, release date and time-stamp on firmware creation.
     */
    func version() throws -> Version {
        
        try device.send(command: .system(.get(.version)))
        let response = try device.read()
        
        guard let version = Version(rawValue: response.rawValue)
            else { throw LoStikError.errorCode(response) }
        
        return version
    }
    
    /**
     This command returns the data stored in the user EEPROM of the module at the requested `address` location.
     */
    func rom(at address: EEPROMAddress) throws -> UInt8 {
        
        try device.send(command: .system(.get(.rom(address))))
        let response = try device.read()
        
        guard let data = UInt8(response.rawValue, radix: 16)
            else { throw LoStikError.errorCode(response) }
        
        return data
    }
    
    /**
     This command requires the module to do an ADC conversion on the VDD. The measurement is converted and returned as a voltage (mV).
     
     - Returns: Decimal value from 0 to 3600.
     */
    func voltage() throws -> UInt {
        
        try device.send(command: .system(.get(.voltage)))
        let response = try device.read()
        
        guard let voltage = UInt(response.rawValue)
            else { throw LoStikError.errorCode(response) }
        
        return voltage
    }
    
    /**
     This command reads the preprogrammed EUI node address from the module.
     The value returned by this command is a globally unique number provided by Microchip.
     
     - Note: The preprogrammed EUI node address is a read-only value and cannot be changed or erased.
     */
    func hardwareIdentifier() throws -> HardwareIdentifier {
        
        try device.send(command: .system(.get(.identifier)))
        let response = try device.read()
        
        guard let number = UInt64(response.rawValue, radix: 16)
            else { throw LoStikError.errorCode(response) }
        
        return HardwareIdentifier(rawValue: number)
    }
    
    /**
     This command returns the state of the queried pin, either ‘0’ (low) or ‘1’ (high).
     */
    func digitalState(for pin: Pin) throws -> Pin.State {
        
        try device.send(command: .system(.get(.digitalPin(pin))))
        let response = try device.read()
        
        guard let stateNumber = Int(response.rawValue),
            let state = Pin.State(rawValue: stateNumber)
            else { throw LoStikError.errorCode(response) }
        
        return state
    }
    
    /**
     This command returns a 10-bit analog value for the queried pin, where 0 represents 0V and 1023 represents VDD. An ADC conversion on the VDD pin can be performed by using `voltage()`.
     */
    func analogState(for pin: Pin) throws -> UInt {
        
        try device.send(command: .system(.get(.analogPin(pin))))
        let response = try device.read()
        
        guard let stateNumber = UInt(response.rawValue)
            else { throw LoStikError.errorCode(response) }
        
        return stateNumber
    }
}

public extension LoStik.System {
    
    public enum Command: Equatable, Hashable {
        
        /**
         This command puts the system to Sleep for the specified number of milliseconds. The module can be forced to exit from Sleep by sending a break condition followed by a 0x55 character at the new baud rate.
         */
        case sleep(UInt)
        
        /**
         This command resets and restarts the module; stored internal configurations will be loaded automatically upon reboot.
         */
        case reset
        
        /**
         This command deletes the current RN2903 module application firmware and prepares it for firmware upgrade. the module bootloader is ready to receive new firmware.
         */
        case eraseFirmware
        
        /**
         This command resets the module’s configuration data and user EEPROM to factory default values and restarts the module. After factoryRESET, the module will automatically reset and all configuration parameters are restored to factory default values.
         */
        case factoryReset
        
        /// System set commands
        case set(Set)
        
        /// System get commands
        case get(Get)
    }
}

public extension LoStik.System.Command {
    
    var type: CommandType {
        
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

internal extension LoStik.System.Command {
    
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

public extension LoStik.System.Command {
    
    public enum Set: Equatable, Hashable {
        
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
}



public extension LoStik.System.Command.Set {
    
    var type: CommandType {
        
        switch self {
        case .rom: return .rom
        case .digitalPin: return .digitalPin
        case .pinMode: return .pinMode
        }
    }
}

internal extension LoStik.System.Command.Set {
    
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

public extension LoStik.System.Command {
    
    public enum Get: Equatable, Hashable {
        
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
}

public extension LoStik.System.Command.Get {
    
    var type: CommandType {
        
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

internal extension LoStik.System.Command.Get {
    
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

public extension LoStik.System.Command {
    
    public enum CommandType: String {
        
        /// Puts the system in Sleep for a finite number of milliseconds.
        case sleep
        
        /// Resets and restarts the module.
        case reset
        
        /// Deletes the current RN2903 module application firmware and prepares it for firmware upgrade.
        /// the module bootloader is ready to receive new firmware.
        case eraseFirmware = "eraseFW"
        
        /// Resets the module’s configuration data and user EEPROM to factory default values and restarts the module.
        case factoryReset = "factoryRESET"
        
        /// Sets specified system parameter values.
        case set
        
        /// Gets specified system parameter values.
        case get
    }
}

public extension LoStik.System.Command.Set {
    
    public enum CommandType: String {
        
        /// Stores <data> to a location <address> of user EEPROM.
        case rom = "nvm"
        
        /// Allows user to set and clear available digital pins.
        case digitalPin = "pindig"
        
        /// Allows the user to set the state of the pins as digital output, digital input or analog.
        case pinMode = "pinmode"
    }
}

public extension LoStik.System.Command.Get {
    
    public enum CommandType: String {
        
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
}
