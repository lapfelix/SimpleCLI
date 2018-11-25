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

    func testHelpStringOneArgKeyValue() {
        let simpleCLI = SimpleCLI(configuration: [Argument(longName: "input", type: .keyAndValue, obligatory: true, description: "File used as input for processing", inputName: "/path/to/file")])
        let helpString = simpleCLI.helpString(["executable", "uh"])
        XCTAssertEqual(helpString, "Usage: executable --input </path/to/file>")
    }

    func testHelpStringOneArgValueOnly() {
        let simpleCLI = SimpleCLI(configuration: [Argument(longName: "input", type: .valueOnly, obligatory: true, description: "File used as input for processing", inputName: "/path/to/file")])
        let helpString = simpleCLI.helpString(["executable", "uh"])
        XCTAssertEqual(helpString, "Usage: executable </path/to/file>")
    }

    func testHelpStringOneArgKeyOnly() {
        let simpleCLI = SimpleCLI(configuration: [Argument(longName: "input", type: .keyOnly, obligatory: true, description: "File used as input for processing", inputName: "/path/to/file")])
        let helpString = simpleCLI.helpString(["executable", "uh"])
        XCTAssertEqual(helpString, "Usage: executable --input")
    }

    func testHelpStringOneOptionalKeyOnly() {
        let simpleCLI = SimpleCLI(configuration: [Argument(longName: "input", shortName: "i", type: .keyOnly, description: "File used as input for processing", inputName: "/path/to/file")])
        let helpString = simpleCLI.helpString(["executable", "uh"])
        XCTAssertEqual(helpString, "Usage: executable [--input | -i]")
    }

    func testHelpStringOneAllTypes() {
        let simpleCLI = SimpleCLI(configuration: [
            Argument(longName: "keyValue",
            shortName: "i", 
            type: .keyAndValue,
            obligatory: true, 
            description: "File used as input for processing", 
            inputName: "/path/to/file"),
            Argument(longName: "valueOnly",
            shortName: "i", 
            type: .valueOnly,
            obligatory: true, 
            description: "File used as input for processing", 
            inputName: "valueOnly"),
            Argument(longName: "keyOnly",
            type: .keyOnly,
            obligatory: true, 
            description: "File used as input for processing"),])

        let helpString = simpleCLI.helpString(["executable", "uh"])
        XCTAssertEqual(helpString, "Usage: executable --keyValue </path/to/file> <valueOnly> --keyOnly")
    }

    func testBluetoothConnectorTest() {
        let simpleCLI = SimpleCLI(configuration: [
            Argument(longName: "connect",
            shortName: "c", 
            type: .keyOnly, 
            description: "Use to always connect (instead of the default toggle behavior)", 
            inputName: "/path/to/file"),
            Argument(longName: "disconnect",
            shortName: "d", 
            type: .keyOnly,
            description: "Use to always disconnect (instead of the default toggle behavior)", 
            inputName: "valueOnly"),
            Argument(longName: "macAddress",
            type: .valueOnly,
            obligatory: true, 
            description: "File used as input for processing",
            inputName: "00-00-00-00-00-00"),])

        let helpString = simpleCLI.helpString(["executable", "uh"])
        XCTAssertEqual(helpString, "Usage: executable [--connect | -c] [--disconnect | d] 00-00-00-00-00-00")
    }

    static var allTests = [
        ("testSimpleArg", testSimpleArg),
        ("testTwoArgs", testTwoArgs),
        ("testSingleValueArgSuccess", testSingleValueArgSuccess),
        ("testSingleValueArgFailure", testSingleValueArgFailure),
        ("testNoConfigFailure", testNoConfigFailure),
        ("testHelpStringOneArgKeyValue", testHelpStringOneArgKeyValue),
    ]
}
