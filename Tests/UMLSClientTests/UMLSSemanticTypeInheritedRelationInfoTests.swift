//  UMLSSemanticTypeInheritedRelationInfoTests.swift

import Combine
import XCTest

@testable import UMLSClient

final class UMLSSemanticTypeInheritedRelationInfoTests: XCTestCase, XCTDecodingErrorAssertion {

  typealias Element = UMLSSemanticTypeInheritedRelationInfo

  var jsonDecoder: JSONDecoder!
  var jsonEncoder: JSONEncoder!

  override func setUp() {
    self.jsonDecoder = .init()
    self.jsonEncoder = .init()
  }

  func semanticTypeInheritedRelationInfo(
    type: JSONValue<Any> = .present(UMLSSemanticTypeRelationLabel.random().rawValue),
    relation: JSONValue<Any> = .present(UMLSSemanticValue.random().rawValue)
  ) -> Data {
    let dict = JSONSerializationDictionary.semanticTypeInheritedRelationInfo(
      type: type,
      relation: relation
    )
    return try! JSONSerialization.data(withJSONObject: dict)
  }

  func semanticTypeInheritedRelationInfo(
    type: JSONValue<UMLSSemanticTypeRelationLabel>, relation: JSONValue<UMLSSemanticValue>
  ) -> Data {

    var typ: JSONValue<Any> = .absent
    if case JSONValue<UMLSSemanticTypeRelationLabel>.present(let value) = type {
      typ = .present(value?.rawValue)
    }

    var rel: JSONValue<Any> = .absent
    if case JSONValue<UMLSSemanticValue>.present(let value) = relation {
      rel = .present(value?.rawValue)
    }

    return semanticTypeInheritedRelationInfo(type: typ, relation: rel)

  }

  func testWithValidJSON() throws {
    let type: UMLSSemanticTypeRelationLabel = .random()
    let relation: UMLSSemanticValue = .random()
    let result = try toObject(
      from: semanticTypeInheritedRelationInfo(type: .present(type), relation: .present(relation))
    )
    XCTAssertEqual(result.type, type)
    XCTAssertEqual(result.relation, relation)
  }

  func keyNotFound(
    codingKey stringValue: String,
    debugDescription string: String,
    type: JSONValue<UMLSSemanticTypeRelationLabel> = .absent,
    relation: JSONValue<UMLSSemanticValue> = .absent
  ) {
    keyNotFound(from: semanticTypeInheritedRelationInfo(type: type, relation: relation)) {
      key, context in
      XCTAssertEqual(key.stringValue, stringValue)
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertEqual(context.debugDescription, string)
    }
  }

  func testWithMissingType() throws {
    keyNotFound(
      codingKey: "relationType",
      debugDescription:
        "No value associated with key CodingKeys(stringValue: \"relationType\", intValue: nil) (\"relationType\").",
      relation: .present(.random())
    )
  }

  func testWithMissingRelation() throws {
    keyNotFound(
      codingKey: "relation2",
      debugDescription:
        "No value associated with key CodingKeys(stringValue: \"relation2\", intValue: nil) (\"relation2\").",
      type: .present(.random())
    )
  }

  func dataCorrupted(
    codingKey stringValue: String, debugDescription description: String,
    type: String? = UMLSSemanticTypeRelationLabel.random().rawValue,
    relation: String? = UMLSSemanticValue.random().rawValue
  ) {
    dataCorrupted(
      from: semanticTypeInheritedRelationInfo(
        type: .present(type),
        relation: .present(relation)
      )
    ) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, stringValue)
      XCTAssertEqual(context.debugDescription, description)
    }
  }

  func testWithInvalidTypeStringValue() throws {
    let string = String.randomAlphaNumericString(of: 10)
    dataCorrupted(
      codingKey: "relationType",
      debugDescription:
        "Cannot initialize UMLSSemanticTypeRelationLabel from invalid String value \(string)",
      type: string
    )
  }

  func testWithInvalidRelationStringValue() throws {
    let string = String.randomAlphaNumericString(of: 10)
    dataCorrupted(
      codingKey: "relation2",
      debugDescription: "Cannot initialize UMLSSemanticValue from invalid String value \(string)",
      relation: string
    )
  }

  func valueNotFound(
    codingKey stringValue: String,
    type: JSONValue<Any> = .present(UMLSSemanticTypeRelationLabel.random().rawValue),
    relation: JSONValue<Any> = .present(UMLSSemanticValue.random().rawValue)
  ) {
    valueNotFound(from: semanticTypeInheritedRelationInfo(type: type, relation: relation)) {
      dataType, context in
      XCTAssert(dataType is String.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, stringValue)
    }
  }

  func testWithNullType() throws {
    valueNotFound(
      codingKey: "relationType",
      type: .present(nil)
    )
  }

  func testWithNullRelation() throws {
    valueNotFound(
      codingKey: "relation2",
      relation: .present(nil)
    )
  }

  func typeMismatch(
    codingKey stringValue: String,
    debugDescription string: String,
    type: JSONValue<Any> = .present(UMLSSemanticTypeRelationLabel.random().rawValue),
    relation: JSONValue<Any> = .present(UMLSSemanticValue.random().rawValue)
  ) {
    let data = semanticTypeInheritedRelationInfo(type: type, relation: relation)
    typeMismatch(from: data) { type, context in
      XCTAssert(type is String.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.debugDescription, string)
    }
  }

  func testWithInvalidType() throws {
    typeMismatch(
      codingKey: "relationType",
      debugDescription: "Expected to decode String but found number instead.",
      type: .present(Int.random(in: 0..<10))
    )
  }

  func testWithInvalidRelation() throws {
    typeMismatch(
      codingKey: "relation2",
      debugDescription: "Expected to decode String but found number instead.",
      relation: .present(Int.random(in: 0..<10))
    )
  }

}

enum JSONValue<T> {
  case present(_ value: T?)
  case absent
}

func toJSON(dictionary: [String: JSONValue<Any>]) -> Data {
  var dict: [String: Any] = .init()
  for (key, value) in dictionary {
    if case JSONValue<Any>.present(let value) = value {
      dict[key] = value != nil ? value! : NSNull()
    }
  }
  return try! JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted, .sortedKeys])
}

protocol XCTDecodingErrorAssertion {

  associatedtype Element

  var jsonDecoder: JSONDecoder! { get set }
  var jsonEncoder: JSONEncoder! { get set }

}

extension XCTDecodingErrorAssertion where Element: Decodable {

  func toObject(from data: Data) throws -> Element {
    try jsonDecoder.decode(Element.self, from: data)
  }

  func errorBlock(from data: Data, completion: (Error) -> Void) {
    XCTAssertThrowsError(try toObject(from: data)) { error in
      completion(error)
    }
  }

  func dataCorrupted(from data: Data, completion: (DecodingError.Context) -> Void) {
    errorBlock(from: data) { error in
      guard case DecodingError.dataCorrupted(let context) = error else {
        return XCTFail("Unexpected error: \(error)")
      }
      completion(context)
    }
  }

  func keyNotFound(
    from data: Data,
    completion: (CodingKey, DecodingError.Context) -> Void
  ) {
    errorBlock(from: data) { error in
      guard case DecodingError.keyNotFound(let key, let context) = error else {
        return XCTFail("Unexpected error: \(error)")
      }
      completion(key, context)
    }
  }

  func typeMismatch(from data: Data, completion: (Any, DecodingError.Context) -> Void) {
    errorBlock(from: data) { error in
      guard case DecodingError.typeMismatch(let any, let context) = error else {
        return XCTFail("Unexpected error: \(error)")
      }
      completion(any, context)
    }
  }

  func valueNotFound(from data: Data, completion: (Any.Type, DecodingError.Context) -> Void) {
    errorBlock(from: data) { error in
      guard case DecodingError.valueNotFound(let type, let context) = error else {
        return XCTFail("Unexpected error: \(error)")
      }
      completion(type, context)
    }
  }

}

extension XCTDecodingErrorAssertion {

  func toData<T: Encodable>(from object: T) throws -> Data {
    try jsonEncoder.encode(object)
  }

}

extension XCTDecodingErrorAssertion where Element: Encodable & CaseIterable {

  func data() throws -> [Data] {
    try Element.allCases.map { try toData(from: $0) }
  }

}
