import XCTest

@testable import UMLSClient

extension UMLSSemanticTypeRelationLabel: Encodable {}

final class UMLSSemanticTypeRelationLabelTests: XCTestCase {

  var decoder: JSONDecoder!
  var encoder: JSONEncoder!

  override func setUp() {
    self.decoder = .init()
    self.encoder = .init()
  }

  func testWithValidString() throws {
    let relationLabel = UMLSSemanticTypeRelationLabel.random()
    let data = try encoder.encode(relationLabel)
    let result = try decoder.decode(UMLSSemanticTypeRelationLabel.self, from: data)
    XCTAssertEqual(result, relationLabel)
  }

  func testWithInvalidString() throws {
    let string = String.randomAlphaNumericString(of: 10)
    let data = try encoder.encode(string)
    XCTAssertThrowsError(try decoder.decode(UMLSSemanticTypeRelationLabel.self, from: data)) {
      error in
      guard case DecodingError.dataCorrupted(let context) = error else {
        return XCTFail("Unexpected decoding Error: \(error)")
      }
      XCTAssert(context.codingPath.isEmpty)
      XCTAssertEqual(
        context.debugDescription,
        "Cannot initialize UMLSSemanticTypeRelationLabel from invalid String value \(string)")
    }
  }

  // Test valid string in case-insensitive format.
  func testWithCaseInsensitiveString() throws {
    let label = UMLSSemanticTypeRelationLabel.random().rawValue.uppercased()
    let data = try encoder.encode(label)
    XCTAssertThrowsError(try decoder.decode(UMLSSemanticTypeRelationLabel.self, from: data)) {
      error in
      guard case DecodingError.dataCorrupted(let context) = error else {
        return XCTFail("Unexpected decoding Error: \(error)")
      }
      XCTAssert(context.codingPath.isEmpty)
      XCTAssertEqual(
        context.debugDescription,
        "Cannot initialize UMLSSemanticTypeRelationLabel from invalid String value \(label)")
    }
  }

}
