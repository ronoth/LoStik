//
//  Hexadecimal.swift
//  LoStik
//
//  Created by Alsey Coleman Miller on 3/14/19.
//

import Foundation

internal extension UInt8 {
    
    func toHexadecimal() -> String {
        
        var string = String(self, radix: 16)
        
        if string.utf8.count < 2 {
            
            string = "0" + string
        }
        
        return string.uppercased()
    }
}

internal extension UInt16 {
    
    func toHexadecimal() -> String {
        
        var string = String(self, radix: 16)
        
        while string.utf8.count < 2 {
            
            // prepend zeroes
            string = "0" + string
        }
        
        return string.uppercased()
    }
}

internal extension UInt64 {
    
    func toHexadecimal() -> String {
        
        var string = String(self, radix: 16)
        
        while string.utf8.count < (MemoryLayout<UInt64>.size * 2) {
            
            // prepend zeroes
            string = "0" + string
        }
        
        return string.uppercased()
    }
}

internal extension Data {
    
    init?(hexadecimal: String) {
        
        guard hexadecimal.isEmpty == false
            else { return nil }
        
        var string = hexadecimal
        
        // prepend 0 if odd number of characters
        while string.count % 2 != 0 {

            string = "0" + string
        }
        
        let length = string.count / 2
        
        var data = Data(capacity: length)
        
        let stringSize = 2
        for index in stride(from: 0, to: string.count, by: stringSize) {
            let hexString = string[string.index(string.startIndex, offsetBy: index) ..< string.index(string.startIndex, offsetBy: Swift.min(index + stringSize, string.count))]
            assert(hexString.count == 2)
            guard let hexValue = UInt8(hexString, radix: 16)
                else { return nil } // not hex value
            data.append(hexValue)
        }
        
        assert(data.count == length)
        
        self = data
    }
    
    func toHexadecimal() -> String {
        
        return reduce("", { $0 + $1.toHexadecimal() })
    }
}
