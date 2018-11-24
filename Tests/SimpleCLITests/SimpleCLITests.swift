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
        let simpleCLI = SimpleCLI(configuration: [Argument(longName: "input", shortName: "i", type: .keyAndValue, obligatory: true, description: "File used as input for processing", inputName: "/path/to/file")])
        let helpString = simpleCLI.helpString(["executable", "uh"])
        XCTAssertEqual(helpString, "Usage: executable --input </path/to/file>")
    }

    func testHelpStringOneArgValueOnly() {
        let simpleCLI = SimpleCLI(configuration: [Argument(longName: "input", shortName: "i", type: .valueOnly, obligatory: true, description: "File used as input for processing", inputName: "/path/to/file")])
        let helpString = simpleCLI.helpString(["executable", "uh"])
        XCTAssertEqual(helpString, "Usage: executable </path/to/file>")
    }

    func testHelpStringOneArgKeyOnly() {
        let simpleCLI = SimpleCLI(configuration: [Argument(longName: "input", shortName: "i", type: .keyOnly, obligatory: true, description: "File used as input for processing", inputName: "/path/to/file")])
        let helpString = simpleCLI.helpString(["executable", "uh"])
        XCTAssertEqual(helpString, "Usage: executable --input")
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
            shortName: "i", 
            type: .keyOnly,
            obligatory: true, 
            description: "File used as input for processing"),])

        let helpString = simpleCLI.helpString(["executable", "uh"])
        XCTAssertEqual(helpString, "Usage: executable --keyValue </path/to/file> <valueOnly> --keyOnly")
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
