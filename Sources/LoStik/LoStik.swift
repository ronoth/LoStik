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
            minimumBytesToRead: 2, // FIXME: 2?
            timeout: 0,
            parityType: .none,
            dataBitsSize: .bits8
        )
    }
    
    internal func send(command: Command) throws {
        
        let _ = try serialPort.writeString(command.description + String(CChar(0x0D)) + String(CChar(0x0A)))
    }
    
    internal func read() throws -> String {
        
        return try serialPort.readLine() //.readUntilChar(CChar(0x0D))
    }
}
