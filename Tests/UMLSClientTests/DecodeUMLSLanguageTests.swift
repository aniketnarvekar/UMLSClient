// DecodeUMLSLanguageTests.swift

import XCTest

@testable import UMLSClient

final class DecodeUMLSLanguageAbbreviationTests: XCTestCase, XCTDecodingErrorAssertion {

  typealias Element = UMLSLanguageAbbreviation

  var jsonDecoder: JSONDecoder!
  var jsonEncoder: JSONEncoder!

  override func setUp() {
    self.jsonDecoder = .init()
    self.jsonEncoder = .init()
  }

  func testWithValidJSON() throws {
    let sets = zip(UMLSLanguageAbbreviation.allCases, try data())
    for (value, data) in sets {
      let result = try toObject(from: data) as UMLSLanguageAbbreviation
      XCTAssertEqual(value, result)
    }
  }

  func testWithInvalidFormattedJSON() throws {
    let data = [
      "",
      String.randomNumericString(of: 10),
    ].map {
      try! toData(from: $0)
    }

    for data in data {
      dataCorrupted(from: data) { context in
        XCTAssertTrue(context.codingPath.isEmpty)
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testWithInvalidTypeJSON() throws {
    let values: [Encodable] = [
      Int.random(in: Int.min...Int.max),
      Array<Int>.init(),
      (0..<10).map { $0 },
      Bool.random(),
    ]

    let data =
      values
      .map {
        try! toData(from: $0)
      }

    for data in data {
      typeMismatch(from: data) { typ, context in
        XCTAssert(typ is String.Type)
        XCTAssertTrue(context.codingPath.isEmpty)
        XCTAssertNil(context.underlyingError)
      }
    }
  }

}

#if SourceVocabulary

  final class DecodeUMLSLanguageNameTests: XCTestCase, XCTDecodingErrorAssertion {

    typealias Element = UMLSLanguageName

    var jsonDecoder: JSONDecoder!
    var jsonEncoder: JSONEncoder!

    override func setUp() {
      self.jsonDecoder = .init()
      self.jsonEncoder = .init()
    }

    func testWithValidJSON() throws {
      let sets = zip(UMLSLanguageName.allCases, try data())
      for (value, data) in sets {
        let result = try jsonDecoder.decode(UMLSLanguageName.self, from: data)
        XCTAssertEqual(result, value)
      }
    }

    func testWithInvalidFormattedJSONString() throws {
      let data = [
        "",
        .randomBoolString(),
        .randomNumericString(of: 10),
        .randomAlphaNumericString(of: 20),
      ]
      .map { try! jsonEncoder.encode($0) }

      for data in data {
        dataCorrupted(from: data) { context in
          XCTAssertTrue(context.codingPath.isEmpty)
          XCTAssertNil(context.underlyingError)
        }
      }

    }

    func testWithInvalidTypeJSON() throws {
      let list: [Encodable] = [
        Int.random(in: Int.min...Int.max),
        Bool.random(),
        [Int](),
      ]

      let data =
        list
        .map { try! jsonEncoder.encode($0) }

      for data in data {
        typeMismatch(from: data) { type, context in
          XCTAssert(type is String.Type)
          XCTAssertTrue(context.codingPath.isEmpty)
          XCTAssertNil(context.underlyingError)
        }
      }

    }

  }

  final class JSONDecodeLanguageInfoTests: XCTestCase, XCTDecodingErrorAssertion {

    typealias Element = UMLSLanguageInfo

    var jsonDecoder: JSONDecoder!
    var jsonEncoder: JSONEncoder!

    override func setUp() {
      self.jsonDecoder = .init()
      self.jsonEncoder = .init()
    }

    func jsonData(
      abbreviation: JSONValue<Any> = .present(UMLSLanguageAbbreviation.random().rawValue),
      name: JSONValue<Any> = .present(UMLSLanguageName.random().rawValue)
    ) throws -> Data {
      let dictionary = JSONSerializationDictionary.languageInfo(
        abbreviation: abbreviation, name: name)
      return try JSONSerialization.data(withJSONObject: dictionary)
    }

    func testWithValidJSON() throws {
      let abbreviation = UMLSLanguageAbbreviation.random()
      let name = UMLSLanguageName.random()
      let data = try jsonData(
        abbreviation: .present(abbreviation.rawValue),
        name: .present(name.rawValue))

      let result = try toObject(from: data)
      XCTAssertEqual(result.abbreviation, abbreviation)
      XCTAssertEqual(result.name, name)
    }

    func testWithInvalidAbbreviationFormattedJSONString() throws {
      let data = try jsonData(abbreviation: .present(String.randomAlphaNumericString(of: 10)))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "abbreviation")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testMissingAbbreviation() throws {
      let data = try jsonData(abbreviation: .absent)
      keyNotFound(from: data) { codingKey, context in
        XCTAssertEqual(codingKey.stringValue, "abbreviation")
        XCTAssertTrue(context.codingPath.isEmpty)
        XCTAssertNil(context.underlyingError)
      }
    }

    func testNullAbbreviation() throws {
      let data = try jsonData(abbreviation: .present(nil))
      valueNotFound(from: data) { type, context in
        XCTAssert(type is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "abbreviation")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testWithInvalidAbbreviationKeyType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 1.0..<10.0),
        Bool.random(),
      ]

      for element in list {
        let data = try jsonData(abbreviation: .present(element))
        typeMismatch(from: data) { type, context in
          XCTAssert(type is String.Type)
          XCTAssertFalse(context.codingPath.isEmpty)
          XCTAssertEqual(context.codingPath[0].stringValue, "abbreviation")
          XCTAssertNil(context.underlyingError)
        }
      }

    }

    func testWithInvalidExpanedFormFormattedJSONStirng() throws {
      let data = try jsonData(name: .present(String.randomAlphaNumericString(of: 10)))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "expandedForm")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testNullExpandedForm() throws {
      let data = try jsonData(name: .present(nil))
      valueNotFound(from: data) { type, context in
        XCTAssert(type is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "expandedForm")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testMissingExpandedForm() throws {
      let data = try jsonData(name: .absent)
      keyNotFound(from: data) { key, context in
        XCTAssertEqual(key.stringValue, "expandedForm")
        XCTAssertTrue(context.codingPath.isEmpty)
        XCTAssertNil(context.underlyingError)
      }
    }

    func testWithExpandedFormKeyType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 1.0..<10.0),
        Bool.random(),
      ]

      for element in list {
        let data = try jsonData(name: .present(element))
        typeMismatch(from: data) { type, context in
          XCTAssert(type is String.Type)
          XCTAssertFalse(context.codingPath.isEmpty)
          XCTAssertEqual(context.codingPath[0].stringValue, "expandedForm")
          XCTAssertNil(context.underlyingError)
        }
      }

    }

  }

  final class DecodeUMLSLanguageTypeObject: XCTestCase, XCTDecodingErrorAssertion {

    typealias Element = UMLSLanguageTypeObject<UMLSLanguageInfo>

    var jsonDecoder: JSONDecoder!
    var jsonEncoder: JSONEncoder!

    override func setUp() {
      self.jsonDecoder = .init()
      self.jsonEncoder = .init()
    }

    func jsonData(classType: JSONValue<Any> = .present(UMLSObject.language.rawValue)) -> Data {
      let dictionary = JSONSerializationDictionary.languageInfo(classType: classType)
      return try! JSONSerialization.data(withJSONObject: dictionary)
    }

    func testWithValidClassName() throws {
      XCTAssertNoThrow(try toObject(from: jsonData()))
    }

    func testWithUnsupportedClassName() throws {
      var data = jsonData(classType: .present(UMLSObject.contentInfo.rawValue))
      XCTAssertThrowsError(try toObject(from: data))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "classType")
        XCTAssertNil(context.underlyingError)
        XCTAssertEqual(context.debugDescription, "Unsupported class type ContactInformation")
      }

      data = jsonData(classType: .present(String.randomAlphaNumericString(of: 10)))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "classType")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testMissingClassType() throws {
      let data = jsonData(classType: .absent)
      XCTAssertThrowsError(try toObject(from: data))
      keyNotFound(from: data) { key, context in
        XCTAssertEqual(key.stringValue, "classType")
        XCTAssertTrue(context.codingPath.isEmpty)
        XCTAssertNil(context.underlyingError)
      }
    }

    func testNullClassType() throws {
      let data = jsonData(classType: .present(nil))
      valueNotFound(from: data) { type, context in
        XCTAssert(type is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "classType")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testInvalidClassTypeKeyType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 1.0..<10.0),
        Bool.random(),
      ]

      for element in list {
        let data = jsonData(classType: .present(element))
        typeMismatch(from: data) { type, context in
          XCTAssert(type is String.Type)
          XCTAssertFalse(context.codingPath.isEmpty)
          XCTAssertEqual(context.codingPath[0].stringValue, "classType")
          XCTAssertNil(context.underlyingError)
        }
      }

    }

  }

#endif
