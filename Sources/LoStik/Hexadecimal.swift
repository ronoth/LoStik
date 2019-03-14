//
//  Hexadecimal.swift
//  LoStik
//
//  Created by Alsey Coleman Miller on 3/14/19.
//

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
