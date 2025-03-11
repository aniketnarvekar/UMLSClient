//  DecodeSemanticTypeGroupInfo.swift

import XCTest

@testable import UMLSClient

final class DecodeSemanticTypeGroupInfo: XCTestCase, XCTDecodingErrorAssertion {

  typealias Element = UMLSSemanticTypeGroupInfo

  var jsonDecoder: JSONDecoder!
  var jsonEncoder: JSONEncoder!

  override func setUp() {
    self.jsonDecoder = .init()
    self.jsonEncoder = .init()
  }

  func groupInfo(
    abbreviation: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    name: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    count: JSONValue<Any> = .present(UInt.random(in: 0..<UInt.max))
  ) -> Data {
    toJSON(dictionary: [
      "abbreviation": abbreviation,
      "expandedForm": name,
      "semanticTypeCount": count,
    ])
  }

  func testWithValidJSON() throws {
    let abbreviation = String.randomAlphaNumericString(of: 10)
    let name = String.randomAlphaNumericString(of: 10)
    let count = UInt.random(in: 0..<UInt.max)
    let data = groupInfo(
      abbreviation: .present(abbreviation), name: .present(name), count: .present(count))
    let result = try toObject(from: data)
    XCTAssertEqual(result.abbreviation, abbreviation)
    XCTAssertEqual(result.name, name)
    XCTAssertEqual(result.count, count)
  }

  func missingFiled(
    codingKey stringValue: String, debugDescription description: String,
    abbreviation: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    name: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    count: JSONValue<Any> = .present(UInt.random(in: 0..<UInt.max))
  ) {
    let data = groupInfo(abbreviation: abbreviation, name: name, count: count)
    keyNotFound(from: data) { key, context in
      XCTAssertEqual(key.stringValue, stringValue)
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertEqual(context.debugDescription, description)
      XCTAssertNil(context.underlyingError)
    }
  }

  func testWithMissingAbbreviation() throws {
    missingFiled(
      codingKey: "abbreviation",
      debugDescription:
        "No value associated with key CodingKeys(stringValue: \"abbreviation\", intValue: nil) (\"abbreviation\").",
      abbreviation: .absent
    )
  }

  func testWithMissingName() throws {
    missingFiled(
      codingKey: "expandedForm",
      debugDescription:
        "No value associated with key CodingKeys(stringValue: \"expandedForm\", intValue: nil) (\"expandedForm\").",
      name: .absent
    )
  }

  func testWithMissingCount() throws {
    missingFiled(
      codingKey: "semanticTypeCount",
      debugDescription:
        "No value associated with key CodingKeys(stringValue: \"semanticTypeCount\", intValue: nil) (\"semanticTypeCount\").",
      count: .absent
    )
  }

  func testNegativeCount() throws {
    let negNum = Int8.random(in: Int8.min..<0)
    let data = groupInfo(count: .present(negNum))
    dataCorrupted(from: data) { context in
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertEqual(context.debugDescription, "The given data was not valid JSON.")
      XCTAssertNotNil(context.underlyingError)
      let error = context.underlyingError! as NSError
      XCTAssertEqual(error.domain, NSCocoaErrorDomain)
      XCTAssertEqual(error.code, 3840)
      XCTAssertFalse(error.userInfo.isEmpty)
      XCTAssertNotNil(error.userInfo[NSDebugDescriptionErrorKey])
      XCTAssertTrue(error.userInfo[NSDebugDescriptionErrorKey]! is String)
      XCTAssertEqual(
        error.userInfo[NSDebugDescriptionErrorKey]! as! String,
        "Number \(negNum) is not representable in Swift."
      )
    }
  }

  func testNullAbbreviation() throws {
    let data = groupInfo(abbreviation: .present(nil))
    valueNotFound(from: data) { dataType, context in
      XCTAssert(dataType is String.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath.count, 1)
      XCTAssertEqual(context.codingPath[0].stringValue, "abbreviation")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testNullName() throws {
    let data = groupInfo(name: .present(nil))
    valueNotFound(from: data) { dataType, context in
      XCTAssert(dataType is String.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath.count, 1)
      XCTAssertEqual(context.codingPath[0].stringValue, "expandedForm")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testNullCount() throws {
    let data = groupInfo(count: .present(nil))
    valueNotFound(from: data) { dataType, context in
      XCTAssert(dataType is UInt.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath.count, 1)
      XCTAssertEqual(context.codingPath[0].stringValue, "semanticTypeCount")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testInvalidAbbreviationType() throws {
    let data = groupInfo(abbreviation: .present(Int.random(in: Int.min...Int.max)))
    typeMismatch(from: data) { value, context in
      XCTAssert(value is String.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath.count, 1)
      XCTAssertEqual(context.codingPath[0].stringValue, "abbreviation")
      XCTAssertEqual(
        context.debugDescription, "Expected to decode String but found number instead.")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testInvalidNameType() throws {
    let data = groupInfo(name: .present(Int.random(in: Int.min...Int.max)))
    typeMismatch(from: data) { value, context in
      XCTAssert(value is String.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath.count, 1)
      XCTAssertEqual(context.codingPath[0].stringValue, "expandedForm")
      XCTAssertEqual(
        context.debugDescription, "Expected to decode String but found number instead.")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testInvalidCountType() throws {
    let data = groupInfo(count: .present(String.randomNumericString(of: 10)))
    typeMismatch(from: data) { value, context in
      XCTAssert(value is UInt.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath.count, 1)
      XCTAssertEqual(context.codingPath[0].stringValue, "semanticTypeCount")
      XCTAssertEqual(
        context.debugDescription, "Expected to decode UInt but found a string instead.")
      XCTAssertNil(context.underlyingError)
    }
  }

}
