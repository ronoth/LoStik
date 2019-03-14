import Foundation
import XCTest
@testable import LoStik

final class LoStikTests: XCTestCase {
    
    static var allTests = [
        ("testCommand", testCommand),
        ]
    
    func testCommand() {
        
    }
    
    func testVersion() {
        
        let string = "RN2903 1.0.3 Aug  8 2017 15:11:09"
        
        guard let version = Version(rawValue: string)
            else { XCTFail("Invalid string \(string)"); return }
        
        XCTAssertEqual(version.rawValue, string)
        XCTAssertEqual(version.description, string)
    }
    
}
