//
//  HardwareIdentifier.swift
//  LoStik
//
//  Created by Alsey Coleman Miller on 3/14/19.
//

/// Hexadecimal number representing the preprogrammed EUI node address. 
public struct HardwareIdentifier: Equatable, Hashable, RawRepresentable {
    
    public let rawValue: UInt64
    
    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }
}

// MARK: - CustomStringConvertible

extension HardwareIdentifier: CustomStringConvertible {
    
    public var description: String {
        
        return rawValue.toHexadecimal()
    }
}
