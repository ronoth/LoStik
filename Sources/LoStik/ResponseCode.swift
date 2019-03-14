//
//  ResponseCode.swift
//  LoStik
//
//  Created by Alsey Coleman Miller on 3/14/19.
//

/// LoStik Response Code
public struct ResponseCode: Equatable, Hashable, RawRepresentable {
    
    public let rawValue: String
    
    public init(rawValue: String) {
        
        self.rawValue = rawValue
    }
}

public extension ResponseCode {
    
    /// Success.
    static let ok: ResponseCode = "ok"
    
    /// If parameters are not valid.
    static let invalidParameters: ResponseCode = "invalid_param"
    
    /// If the network is not joined.
    static let notJoined: ResponseCode = "not_joined"
    
    /// No channels are available
    static let noAvailibleChannels: ResponseCode = "no_free_ch"
}

// MARK: - CustomStringConvertible

extension ResponseCode: CustomStringConvertible {
    
    public var description: String {
        
        return rawValue
    }
}

// MARK: - ExpressibleByStringLiteral

extension ResponseCode: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        
        self.init(rawValue: value)
    }
}


