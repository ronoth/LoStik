import Foundation
import XCTest
@testable import LoStik

final class LoStikTests: XCTestCase {
    
    static var allTests = [
        ("testCommand", testCommand),
        ("testVersion", testVersion)
        ]
    
    func testCommand() {
        
        let commands: [(Command, String)] = [
            (.system(.sleep(120)), "sys sleep 120"),
            (.system(.reset), "sys reset"),
            (.system(.eraseFirmware), "sys eraseFW"),
            (.system(.factoryReset), "sys factoryRESET"),
            (.system(.set(.rom(.min, 0xA5))), "sys set nvm 300 A5"),
            (.system(.set(.digitalPin(.gpio5, .on))), "sys set pindig GPIO5 1"),
            (.system(.set(.pinMode(.gpio5, .analog))), "sys set pinmode GPIO5 ana"),
            (.system(.get(.version)), "sys get ver"),
            (.system(.get(.rom(.min))), "sys get nvm 300"),
            (.system(.get(.voltage)), "sys get vdd"),
            (.system(.get(.identifier)), "sys get hweui"),
            (.system(.get(.digitalPin(.gpio5))), "sys get pindig GPIO5"),
            (.system(.get(.analogPin(.gpio0))), "sys get pinana GPIO0"),
        ]
        
        for (command, string) in commands {
            XCTAssertEqual(command.description, string)
        }
    }
    
    func testVersion() {
        
        let string = "RN2903 1.0.3 Aug 8 2017 15:11:09"
        
        guard let version = Version(rawValue: string)
            else { XCTFail("Invalid string \(string)"); return }
        
        XCTAssertEqual(version.rawValue, string)
        XCTAssertEqual(version.description, string)
    }
    
}
