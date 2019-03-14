//
//  EEPROMAddress.swift
//  LoStik
//
//  Created by Alsey Coleman Miller on 3/14/19.
//

/**
 EEPROM address
 
 Hexadecimal number representing user EEPROM address, from `0x300` to `0x3FF`
 */
public struct EEPROMAddress: RawRepresentable, Equatable, Hashable {
    
    public let rawValue: UInt16
    
    public init?(rawValue: UInt16) {
        
        guard rawValue >= EEPROMAddress.min.rawValue,
            rawValue <= EEPROMAddress.max.rawValue
            else { return nil }
        
        self.rawValue = rawValue
    }
    
    private init(_ unsafe: UInt16) {
        
        self.rawValue = unsafe
    }
}

public extension EEPROMAddress {
    
    public static var min: EEPROMAddress { return EEPROMAddress(0x300) }
    
    public static var max: EEPROMAddress { return EEPROMAddress(0x3FF) }
}

extension EEPROMAddress: CustomStringConvertible {
    
    public var description: String {
        
        return rawValue.toHexadecimal()
    }
}
