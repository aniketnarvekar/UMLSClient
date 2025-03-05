//  UMLSSemanticTypeRelationInfoTests.swift

import XCTest

@testable import UMLSClient

#if SemanticType

  final class UMLSSemanticTypeRelationInfoTests: XCTestCase {

    func semanticTypeRelationInfoJSON(
      type: String? = UMLSSemanticTypeRelationLabel.random().rawValue,
      relation: String? = UMLSSemanticValue.random().rawValue,
      flag: String? = UMLSSemanticTypeFlag.random().rawValue
    ) -> Data {
      let dict =
        JSONSerializationDictionary
        .semanticTypeRelationInfo(
          type: type != nil ? .present(type) : .absent,
          relation: relation != nil ? .present(relation) : .absent,
          flag: flag != nil ? .present(flag) : .absent
        )
      return try! JSONSerialization.data(withJSONObject: dict)
    }

    func semanticTypeRelationInfoJSON(
      type: UMLSSemanticTypeRelationLabel? = nil,
      relation: UMLSSemanticValue? = nil,
      flag: UMLSSemanticTypeFlag? = nil
    ) -> Data {
      semanticTypeRelationInfoJSON(
        type: type?.rawValue,
        relation: relation?.rawValue,
        flag: flag?.rawValue
      )
    }

    var jsonDecoder: JSONDecoder!

    override func setUp() {
      self.jsonDecoder = .init()
    }

    func testWithValidJSON() throws {
      let type: UMLSSemanticTypeRelationLabel = .random()
      let relation: UMLSSemanticValue = .random()
      let flag: UMLSSemanticTypeFlag = .random()
      let result = try jsonDecoder.decode(
        UMLSSemanticTypeRelationInfo.self,
        from: semanticTypeRelationInfoJSON(type: type, relation: relation, flag: flag)
      )
      XCTAssertEqual(result.type, type)
      XCTAssertEqual(result.relation, relation)
      XCTAssertEqual(result.flag, flag)
    }

    func keyNotFoundError(
      type: UMLSSemanticTypeRelationLabel? = nil,
      relation: UMLSSemanticValue? = nil,
      flag: UMLSSemanticTypeFlag? = nil,
      codingKey stringValue: String,
      debugDescription string: String
    ) {
      XCTAssertThrowsError(
        try jsonDecoder
          .decode(
            UMLSSemanticTypeRelationInfo.self,
            from: semanticTypeRelationInfoJSON(type: type, relation: relation, flag: flag)
          )
      ) { error in
        guard case DecodingError.keyNotFound(let key, let context) = error else {
          return XCTFail("Unexpected error: \(error)")
        }
        XCTAssertEqual(key.stringValue, stringValue)
        XCTAssert(context.codingPath.isEmpty)
        XCTAssertEqual(context.debugDescription, string)
      }
    }

    func testWithMissingTypeField() throws {
      keyNotFoundError(
        relation: .random(),
        flag: .random(),
        codingKey: "type",
        debugDescription:
          "No value associated with key CodingKeys(stringValue: \"type\", intValue: nil) (\"type\")."
      )
    }

    func testWithMissingRelationField() throws {
      keyNotFoundError(
        type: .random(),
        flag: .random(),
        codingKey: "relation",
        debugDescription:
          "No value associated with key CodingKeys(stringValue: \"relation\", intValue: nil) (\"relation\")."
      )
    }

    func testWithMissingFlagField() throws {
      keyNotFoundError(
        type: .random(),
        relation: .random(),
        codingKey: "flag",
        debugDescription:
          "No value associated with key CodingKeys(stringValue: \"flag\", intValue: nil) (\"flag\")."
      )
    }

    func dataCorruptedError(
      type: String? = UMLSSemanticTypeRelationLabel.random().rawValue,
      relation: String? = UMLSSemanticValue.random().rawValue,
      flag: String? = UMLSSemanticTypeFlag.random().rawValue,
      codingPath stringValue: String,
      debugDescription string: String
    ) {
      XCTAssertThrowsError(
        try jsonDecoder
          .decode(
            UMLSSemanticTypeRelationInfo.self,
            from: semanticTypeRelationInfoJSON(type: type, relation: relation, flag: flag)
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

    func testWithInvalidTypeFieldValue() throws {
      let string = String.randomAlphaNumericString(of: 10)
      dataCorruptedError(
        type: string,
        codingPath: "type",
        debugDescription:
          "Cannot initialize UMLSSemanticTypeRelationLabel from invalid String value \(string)"
      )
    }

    func testWithInvalidRelationFieldValue() throws {
      let string = String.randomAlphaNumericString(of: 10)
      dataCorruptedError(
        relation: string,
        codingPath: "relation",
        debugDescription: "Cannot initialize UMLSSemanticValue from invalid String value \(string)"
      )
    }

    func testWithInvalidFlagFieldValue() throws {
      let string = String.randomAlphaNumericString(of: 10)
      dataCorruptedError(
        flag: string,
        codingPath: "flag",
        debugDescription:
          "Cannot initialize UMLSSemanticTypeFlag from invalid String value \(string)"
      )
    }

  }

#endif
