import XCTest
@testable import UMLSClient

final class UMLSSemanticTypeTests: XCTestCase {

    var decoder: JSONDecoder!
    var encoder: JSONEncoder!

    override func setUp() {
        self.decoder = .init()
        self.encoder = .init()
    }

    func testWithValidString() throws {
        // Create JSON data object.
        let semanticTypes = UMLSSemanticType.allCases
        let data = try encoder.encode(semanticTypes)
        // Decode JSON data to object.
        // It doesn't throw error means manage to decode successfully.
        let result = try decoder.decode([UMLSSemanticType].self, from: data)
        // Test sequence of encoded object is same as being decoded.
        XCTAssertEqual(result, semanticTypes)
    }

    func testWithInvalidString() throws {
        let string = String.randomAlphaNumericString(of: 10)
        let data = try encoder.encode(string)
        do {
            _ = try decoder.decode(UMLSSemanticType.self, from: data)
            XCTFail("Unable to raise DecodingError.")
        } catch let error as DecodingError {
            switch error {
            case .dataCorrupted(let context):
                XCTAssert(context.codingPath.isEmpty)
                XCTAssert(true)
            default:
                XCTFail("Unexpected decoding error: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testWithCaseInsensitiveJSONString() throws {
        let semanticType = UMLSSemanticType.random().rawValue.lowercased()
        let data = try encoder.encode(semanticType)
        XCTAssertThrowsError(try decoder.decode(UMLSSemanticType.self, from: data)) { error in
            guard case DecodingError.dataCorrupted(let context) = error else {
                return XCTFail("Unexpected decoding error: \(error)")
            }
            XCTAssert(context.codingPath.isEmpty)
            XCTAssertEqual(
                context.debugDescription,
                "Cannot initialize UMLSSemanticType from invalid String value \(semanticType)"
            )
        }
    }

}
