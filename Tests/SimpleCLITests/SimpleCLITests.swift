import XCTest
@testable import SimpleCLI

final class SimpleCLITests: XCTestCase {
    func testSimpleArg() {
        let simpleCLI = SimpleCLI(configuration: [Argument(longName: "argument1", shortName: "A", type: .keyAndValue, defaultValue: "yes", obligatory: false)])
        let parsed = simpleCLI.parseArgs(["executablepath", "--argument1", "yes"])
        XCTAssertEqual(parsed, ["argument1":"yes"])
    }

    func testTwoArgs() {
        let simpleCLI = SimpleCLI(configuration: [Argument(longName: "argument1", shortName: "A", type: .keyAndValue, defaultValue: "yes", obligatory: false)])
        let parsed = simpleCLI.parseArgs(["executablepath", "oh", "no"])
        XCTAssertEqual(parsed, [:])
    }

    func testSingleValueArgSuccess() {
        let simpleCLI = SimpleCLI(configuration: [Argument.init(longName: "valueOnlyArgument", type: .valueOnly)])
        let parsed = simpleCLI.parseArgs(["executablepath", "oh"])
        XCTAssertEqual(parsed, ["valueOnlyArgument":"oh"])
    }

    func testSingleValueArgFailure() {
        let simpleCLI = SimpleCLI(configuration: [Argument.init(longName: "valueOnlyArgument", type: .valueOnly)])
        let parsed = simpleCLI.parseArgs(["executablepath", "oh", "no"])
        XCTAssertEqual(parsed, [:])
    }

    func testNoConfigFailure() {
        let simpleCLI = SimpleCLI(configuration: [])
        let parsed = simpleCLI.parseArgs(["executablepath", "oh", "no"])
        XCTAssertEqual(parsed, [:])
    }

    static var allTests = [
        ("testSimpleArg", testSimpleArg),
        ("testTwoArgs", testTwoArgs),
        ("testSingleValueArgSuccess", testSingleValueArgSuccess),
        ("testSingleValueArgFailure", testSingleValueArgFailure),
        ("testNoConfigFailure", testNoConfigFailure),
    ]
}
