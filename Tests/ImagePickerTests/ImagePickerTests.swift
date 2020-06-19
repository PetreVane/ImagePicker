import XCTest
@testable import ImagePicker

final class ImagePickerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ImagePicker().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
