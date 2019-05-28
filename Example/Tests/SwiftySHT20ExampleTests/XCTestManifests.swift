import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SwiftySHT20ExampleTests.allTests),
    ]
}
#endif
