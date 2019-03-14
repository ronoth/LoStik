import XCTest
@testable import LoStik

final class LoStikTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LoStik().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
