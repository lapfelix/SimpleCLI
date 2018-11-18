import XCTest

import SimpleCLITests

var tests = [XCTestCaseEntry]()
tests += SimpleCLITests.allTests()
XCTMain(tests)