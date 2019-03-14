//
//  Version.swift
//  LoStik
//
//  Created by Alsey Coleman Miller on 3/14/19.
//

import Foundation

/// LoStik Version Information
public struct Version: Equatable, Hashable {
    
    public let model: Model
    
    public let firmware: FirmwareVersion
    
    public let release: Date
}

private extension Version {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yyyy HH:mm:ss"
        return formatter
    }()
    
    static var separator: String { return " " }
}

// MARK: - RawRepresentable

extension Version: RawRepresentable {
    
    public init?(rawValue: String) {
        
        let components = rawValue.components(separatedBy: Version.separator)
        
        guard components.count >= 3
            else { return nil }
        
        let modelString = components[0]
        
        let firmwareVersionString = components[1]
        
        let releaseDateString = components
            .suffix(from: 2)
            .reduce("", { $0 + ($0.isEmpty ? "" : " ") + $1 })
        
        guard let model = Model(rawValue: modelString),
            let firmwareVersion = FirmwareVersion(rawValue: firmwareVersionString),
            let releaseDate = Version.dateFormatter.date(from: releaseDateString)
            else { return nil }
        
        self.init(model: model, firmware: firmwareVersion, release: releaseDate)
    }
    
    public var rawValue: String {
        
        let components = [model.rawValue, firmware.rawValue, Version.dateFormatter.string(from: release)]
        
        return components.reduce("", { $0 + ($0.isEmpty ? "" : Version.separator) + $1 })
    }
}

// MARK: - CustomStringConvertible

extension Version: CustomStringConvertible {
    
    public var description: String {
        
        return rawValue
    }
}

// MARK: - Supporting Types

public enum Model: String {
    
    /// The RN2903 is a fully-certified 915 MHz module based on wireless LoRa® technology.
    case america = "RN2903"
    
    /// The RN2483 is a fully-certified 433/868 MHz module based on wireless LoRa® technology.
    case europe = "RN2483"
}

/**
 LoStik Firmware Version
 
 `RN2903 X.Y.Z MMM DD YYYY HH:MM:SS`, where X.Y.Z is the firmware version, MMM is month, DD is day, HH:MM:SS is hour, minutes, seconds (format: [HW] [FW] [Date] [Time]). [Date] and [Time] refer to the release of the firmware.
 */
public struct FirmwareVersion: Equatable, Hashable {
    
    public var major: UInt
    
    public var minor: UInt
    
    public var patch: UInt
    
    public init(major: UInt, minor: UInt, patch: UInt) {
        
        self.major = major
        self.minor = minor
        self.patch = patch
    }
}

private extension FirmwareVersion {
    
    static var separator: String { return "." }
}

// MARK: - RawRepresentable

extension FirmwareVersion: RawRepresentable {
    
    public init?(rawValue: String) {
        
        let components = rawValue
            .components(separatedBy: FirmwareVersion.separator)
            .compactMap { UInt($0) }
        
        guard components.count == 3
            else { return nil }
        
        self.init(major: components[0], minor: components[1], patch: components[2])
    }
    
    public var rawValue: String {
        
        let components = [major, minor, patch]
        
        return components.reduce("", { $0 + ($0.isEmpty ? "" : FirmwareVersion.separator) + "\($1)" })
    }
}

// MARK: - CustomStringConvertible

extension FirmwareVersion: CustomStringConvertible {
    
    public var description: String {
        
        return rawValue
    }
}
