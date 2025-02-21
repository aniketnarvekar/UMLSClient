import XCTest

@testable import UMLSClient

#if SemanticType

  extension UMLSSemanticTypeFlag: Encodable {}

  final class UMLSSemanticTypeFlagTests: XCTestCase {

    var decoder: JSONDecoder!
    var encoder: JSONEncoder!

    override func setUp() {
      self.decoder = .init()
      self.encoder = .init()
    }

    func testWithValidJSONString() throws {
      let flag = UMLSSemanticTypeFlag.random()
      let data = try encoder.encode(flag)
      let result = try decoder.decode(UMLSSemanticTypeFlag.self, from: data)
      XCTAssertEqual(result, flag)
    }

    func testWithInvalidJSONString() throws {
      let string = String.randomAlphaNumericString(of: 10)
      let data = try encoder.encode(string)
      XCTAssertThrowsError(try decoder.decode(UMLSSemanticTypeFlag.self, from: data)) { error in
        guard case DecodingError.dataCorrupted(let context) = error else {
          return XCTFail("Unexpected error: \(error)")
        }
        XCTAssert(context.codingPath.isEmpty)
        XCTAssertEqual(
          context.debugDescription,
          "Cannot initialize UMLSSemanticTypeFlag from invalid String value \(string)")

      }
    }

    func testWithCaseInsensitiveJSONString() throws {
      let string = UMLSSemanticTypeFlag.random().rawValue.lowercased()
      let data = try encoder.encode(string)
      XCTAssertThrowsError(try decoder.decode(UMLSSemanticTypeFlag.self, from: data)) { error in
        guard case DecodingError.dataCorrupted(let context) = error else {
          return XCTFail("Unexpected error: \(error)")
        }
        XCTAssert(context.codingPath.isEmpty)
        XCTAssertEqual(
          context.debugDescription,
          "Cannot initialize UMLSSemanticTypeFlag from invalid String value \(string)")
      }
    }

  }

#endif
