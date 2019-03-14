import Foundation
import SwiftSerial

/// LoStik LoRa USB module
///
/// - SeeAlso: [RN2903 LoRaTM Technology Module Command Reference User’s Guide](http://ww1.microchip.com/downloads/en/DeviceDoc/40001811A.pdf)
public final class LoStik {
    
    internal let serialPort: SerialPort
    
    public init(port path: String) throws {
        
        self.serialPort = SerialPort(path: path)
        
        try serialPort.openPort()
        
        serialPort.setSettings(
            receiveRate: .baud57600,
            transmitRate: .baud57600,
            minimumBytesToRead: 0, // FIXME: 2?
            timeout: 10,
            parityType: .none,
            dataBitsSize: .bits8
        )
    }
    
    internal func send(command: Command) throws {
        
        let writtenBytes = try serialPort.writeString(command.description + "\u{000D}\u{000A}")
        
        assert(writtenBytes == command.description.utf8.count + 2)
    }
    
    internal func read() throws -> String {
        
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1)
        
        defer {
            buffer.deallocate()
        }
        
        var data = Data(capacity: 3)
        
        while true {
            let bytesRead = try serialPort.readBytes(into: buffer, size: 1)
            
            guard bytesRead > 0 else { continue }
            
            data.append(buffer[0])
            
            if data.count >= 2,
                data[data.count - 2] == 0x0D,
                data[data.count - 1] == 0x0A {
                
                break
            }
        }
        
        guard let response = String(data: data.prefix(data.count - 2), encoding: .utf8)
            else { throw PortError.stringsMustBeUTF8 }
        
        return response
    }
}
