//  DecodeUMLSSemanticTypeInverseInheritedRelationInfoTests.swift

import XCTest

@testable import UMLSClient

final class DecodeUMLSSemanticTypeInverseInheritedRelationInfoTests: XCTestCase,
  XCTDecodingErrorAssertion
{

  typealias Element = UMLSSemanticTypeInverseInheritedRelationInfo

  var jsonDecoder: JSONDecoder!
  var jsonEncoder: JSONEncoder!

  override func setUp() {
    jsonDecoder = .init()
    jsonEncoder = .init()
  }

  func semanticTypeInverseInheritedRelationInfo(
    type: JSONValue<Any> = .present(
      UMLSSemanticTypeRelationLabel.random().rawValue
    ),
    relation: JSONValue<Any> = .present(UMLSSemanticValue.random().rawValue)
  ) -> Data {
    let dict = JSONSerializationDictionary.semanticTypeInverseInheritedRelationInfo(
      type: type,
      relation: relation
    )
    return try! JSONSerialization.data(withJSONObject: dict)
  }

  func semanticTypeInverseInheritedRelationInfo(
    type: JSONValue<UMLSSemanticTypeRelationLabel> = .present(.random()),
    relation: JSONValue<UMLSSemanticValue> = .present(.random())
  ) -> Data {

    var typ: JSONValue<Any> = .absent
    if case JSONValue<UMLSSemanticTypeRelationLabel>.present(let value) = type {
      typ = .present(value?.rawValue)
    }

    var rel: JSONValue<Any> = .absent
    if case JSONValue<UMLSSemanticValue>.present(let value) = relation {
      rel = .present(value?.rawValue)
    }

    return semanticTypeInverseInheritedRelationInfo(type: typ, relation: rel)

  }

  func testWithValidJSON() throws {
    let type: UMLSSemanticTypeRelationLabel = .random()
    let relation: UMLSSemanticValue = .random()
    let data = semanticTypeInverseInheritedRelationInfo(
      type: .present(type),
      relation: .present(relation)
    )
    let result = try toObject(from: data)
    XCTAssertEqual(result.type, type)
    XCTAssertEqual(result.relation, relation)
  }

  func missingKey(
    codingKey stringValue: String,
    debugDescription description: String,
    type: JSONValue<UMLSSemanticTypeRelationLabel> = .present(.random()),
    relation: JSONValue<UMLSSemanticValue> = .present(.random())
  ) {
    let data = semanticTypeInverseInheritedRelationInfo(
      type: type, relation: relation
    )
    keyNotFound(from: data) { key, context in
      XCTAssertEqual(key.stringValue, stringValue)
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertEqual(context.debugDescription, description)
      XCTAssertNil(context.underlyingError)
    }
  }

  func testWithMissingType() throws {
    missingKey(
      codingKey: "relationType",
      debugDescription:
        "No value associated with key CodingKeys(stringValue: \"relationType\", intValue: nil) (\"relationType\").",
      type: .absent
    )
  }

  func testWithMissingRelation() throws {
    missingKey(
      codingKey: "relation1",
      debugDescription:
        "No value associated with key CodingKeys(stringValue: \"relation1\", intValue: nil) (\"relation1\").",
      relation: .absent
    )
  }

  func invalidFiled(
    codingKey stringValue: String,
    debugDescription description: String,
    type: JSONValue<Any> = .present(
      UMLSSemanticTypeRelationLabel.random().rawValue
    ),
    relation: JSONValue<Any> = .present(UMLSSemanticValue.random().rawValue)
  ) {
    let data = semanticTypeInverseInheritedRelationInfo(
      type: type, relation: relation
    )
    dataCorrupted(from: data) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, stringValue)
      XCTAssertEqual(context.debugDescription, description)
    }
  }

  func testInvalidTypeStringValue() throws {
    let string = String.randomAlphaNumericString(of: 10)
    invalidFiled(
      codingKey: "relationType",
      debugDescription:
        "Cannot initialize UMLSSemanticTypeRelationLabel from invalid String value \(string)",
      type: .present(string)
    )
  }

  func testInvalidRelationStringValue() throws {
    let string = String.randomAlphaNumericString(of: 10)
    invalidFiled(
      codingKey: "relation1",
      debugDescription: "Cannot initialize UMLSSemanticValue from invalid String value \(string)",
      relation: .present(string)
    )
  }

  func nonStringFiledValue(
    codingKey stringValue: String,
    type: JSONValue<Any> = .present(UMLSSemanticTypeRelationLabel.random().rawValue),
    relation: JSONValue<Any> = .present(UMLSSemanticValue.random().rawValue)
  ) {
    let data = semanticTypeInverseInheritedRelationInfo(type: type, relation: relation)
    valueNotFound(from: data) { dataType, context in
      XCTAssert(dataType is String.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, stringValue)
    }
  }

  func testTypeValueNotFound() throws {
    nonStringFiledValue(
      codingKey: "relationType",
      type: .present(nil)
    )
  }

  func testRelationValueNotFound() throws {
    nonStringFiledValue(
      codingKey: "relation1",
      relation: .present(nil)
    )
  }

  func invalidFiledType(
    codingKey stringValue: String,
    debugDesciption description: String,
    type: JSONValue<Any> = .present(UMLSSemanticTypeRelationLabel.random().rawValue),
    relation: JSONValue<Any> = .present(UMLSSemanticValue.random().rawValue)
  ) {
    let data = semanticTypeInverseInheritedRelationInfo(type: type, relation: relation)
    typeMismatch(from: data) { key, context in
      XCTAssert(key is String.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "relationType")
      XCTAssertEqual(
        context.debugDescription, "Expected to decode String but found number instead.")
    }
  }

  func testInvalidTypeFiledType() throws {
    invalidFiledType(
      codingKey: "relationType",
      debugDesciption: "Expected to decode String but found number instead.",
      type: .present(Int.random(in: 0..<100))
    )
  }

  func testInvalidRelationFiledType() throws {
    invalidFiledType(
      codingKey: "relation1",
      debugDesciption: "Expected to decode String but found number instead.",
      type: .present(Int.random(in: 0..<100))
    )
  }

}
