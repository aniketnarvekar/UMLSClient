//  UMLSSemanticTypeInverseRelationInfoTests.swift

import XCTest

@testable import UMLSClient

#if SemanticType

final class UMLSSemanticTypeInverseRelationInfoTests: XCTestCase {

  var jsonDecoder: JSONDecoder!

  override func setUp() {
    self.jsonDecoder = .init()
  }

  func semanticTypeInverseRelationJSON(
    type: String? = UMLSSemanticTypeRelationLabel.random().rawValue,
    relation: String? = UMLSSemanticValue.random().rawValue,
    flag: String? = UMLSSemanticTypeFlag.random().rawValue
  ) -> Data {
    var dict: [String: String] = .init()
    if let type = type {
      dict["type"] = type
    }
    if let relation = relation {
      dict["inverseRelation"] = relation
    }
    if let flag = flag {
      dict["flag"] = flag
    }
    return try! JSONSerialization.data(withJSONObject: dict)
  }

  func semanticTypeInverseRelationJSON(
    type: UMLSSemanticTypeRelationLabel? = nil, relation: UMLSSemanticValue? = nil,
    flag: UMLSSemanticTypeFlag? = nil
  ) -> Data {
    semanticTypeInverseRelationJSON(
      type: type?.rawValue,
      relation: relation?.rawValue,
      flag: flag?.rawValue
    )
  }

  func toObject(from data: Data) throws -> UMLSSemanticTypeInverseRelationInfo {
    try jsonDecoder.decode(UMLSSemanticTypeInverseRelationInfo.self, from: data)
  }

  func testWithValidJSON() throws {
    let type: UMLSSemanticTypeRelationLabel = .random()
    let relation: UMLSSemanticValue = .random()
    let flag: UMLSSemanticTypeFlag = .random()
    let result = try toObject(
      from: semanticTypeInverseRelationJSON(type: type, relation: relation, flag: flag)
    )
    XCTAssertEqual(result.type, type)
    XCTAssertEqual(result.relation, relation)
    XCTAssertEqual(result.flag, flag)
  }

  func keyNotFound(
    codingKey stringValue: String,
    debugDescription string: String,
    type: UMLSSemanticTypeRelationLabel? = nil,
    relation: UMLSSemanticValue? = nil,
    flag: UMLSSemanticTypeFlag? = nil
  ) {
    XCTAssertThrowsError(
      try toObject(
        from: semanticTypeInverseRelationJSON(type: type, relation: relation, flag: flag)
      )
    ) { error in
      guard case DecodingError.keyNotFound(let key, let context) = error else {
        return XCTFail("Unexpected error: \(error)")
      }
      XCTAssertEqual(key.stringValue, stringValue)
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertEqual(context.debugDescription, string)
    }
  }

  func testWithMissingTypeField() throws {
    keyNotFound(
      codingKey: "type",
      debugDescription:
        "No value associated with key CodingKeys(stringValue: \"type\", intValue: nil) (\"type\").",
      relation: .random(),
      flag: .random()
    )
  }

  func testWithMissingRelationField() throws {
    keyNotFound(
      codingKey: "inverseRelation",
      debugDescription:
        "No value associated with key CodingKeys(stringValue: \"inverseRelation\", intValue: nil) (\"inverseRelation\").",
      type: .random(),
      flag: .random()
    )
  }

  func testWithMissingFlagField() throws {
    keyNotFound(
      codingKey: "flag",
      debugDescription:
        "No value associated with key CodingKeys(stringValue: \"flag\", intValue: nil) (\"flag\").",
      type: .random(),
      relation: .random()
    )
  }

  func dataCorrupted(
    codingKey stringValue: String,
    debugDescription string: String,
    type: String? = UMLSSemanticTypeRelationLabel.random().rawValue,
    relation: String? = UMLSSemanticValue.random().rawValue,
    flag: String? = UMLSSemanticTypeFlag.random().rawValue
  ) {
    XCTAssertThrowsError(
      try toObject(
        from: semanticTypeInverseRelationJSON(type: type, relation: relation, flag: flag)
      )
    ) { error in
      guard case DecodingError.dataCorrupted(let context) = error else {
        return XCTFail("Unexpected error: \(error)")
      }
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, stringValue)
      XCTAssertEqual(context.debugDescription, string)
    }
  }

  func testWithInvalidTypeField() throws {
    let string = String.randomAlphaNumericString(of: 10)
    dataCorrupted(
      codingKey: "type",
      debugDescription:
        "Cannot initialize UMLSSemanticTypeRelationLabel from invalid String value \(string)",
      type: string)
  }

  func testWithInvalidRelationField() throws {
    let string = String.randomAlphaNumericString(of: 10)
    dataCorrupted(
      codingKey: "inverseRelation",
      debugDescription:
        "Cannot initialize UMLSSemanticValue from invalid String value \(string)",
      relation: string)
  }

  func testWithInvalidFlagField() throws {
    let string = String.randomAlphaNumericString(of: 10)
    dataCorrupted(
      codingKey: "flag",
      debugDescription:
        "Cannot initialize UMLSSemanticTypeFlag from invalid String value \(string)",
      flag: string)
  }

}

#endif
