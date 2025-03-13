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

  final class DecodeUMLSAddressFieldsTests: XCTestCase, XCTDecodingErrorAssertion {

    typealias Element = UMLSPostalAddress

    var jsonDecoder: JSONDecoder!
    var jsonEncoder: JSONEncoder!

    override func setUp() {
      self.jsonEncoder = .init()
      self.jsonDecoder = .init()
    }

    func jsonData(
      address1: JSONValue<Any> = .present(String.randomStringWithNone()),
      address2: JSONValue<Any> = .present(String.randomStringWithNone()),
      city: JSONValue<Any> = .present(String.randomStringWithNone()),
      stateOrProvince: JSONValue<Any> = .present(String.randomStringWithNone()),
      country: JSONValue<Any> = .present(String.randomStringWithNone()),
      zipCode: JSONValue<Any> = .present(String.randomStringWithNone())
    ) -> Data {
      let dict: [String: Any] = JSONSerializationDictionary.address(
        address1: address1, address2: address2, city: city, stateOrProvince: stateOrProvince,
        country: country, zipCode: zipCode)
      return try! JSONSerialization.data(withJSONObject: dict)
    }

    func testWithValidNonNONEAddress1() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(address1: .present(string))
      XCTAssertNoThrow(try toObject(from: data))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.address1)
      XCTAssertEqual(result.address1!, string)
    }

    func testWithValidNONEAddress1() throws {
      let data = jsonData(address1: .present("NONE"))
      let object = try toObject(from: data)
      XCTAssertNil(object.address1)
    }

    func testWithEmptyAddress1() throws {
      let data = jsonData(address1: .present(""))
      let object = try toObject(from: data)
      XCTAssertNil(object.address1)
    }

    func testWithAddress1PrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map { jsonData(address1: .present($0)) }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.address1)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(address1: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.address1)
        XCTAssertEqual(result.address1, "xyz")
      }

    }

    func assertTypeMismatch(from data: Data, _ string: String) {
      typeMismatch(from: data) { type, context in
        XCTAssert(type is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, string)
        XCTAssertNil(context.underlyingError)
      }
    }

    func testInvalidAddress1Type() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(address1: .present(element))
        assertTypeMismatch(from: data, "address1")
      }
    }

    func assertMissing(from data: Data, _ string: String) {
      keyNotFound(from: data) { key, context in
        XCTAssertEqual(key.stringValue, string)
        XCTAssertTrue(context.codingPath.isEmpty)
        XCTAssertNil(context.underlyingError)
      }
    }

    func testMissingAddress1() throws {
      let data = jsonData(address1: .absent)
      assertMissing(from: data, "address1")
    }

    func assertNull(from data: Data, _ string: String) {
      valueNotFound(from: data) { type, context in
        XCTAssert(type is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, string)
        XCTAssertNil(context.underlyingError)
      }
    }

    func testNullAddress1() throws {
      let data = jsonData(address1: .present(nil))
      assertNull(from: data, "address1")
    }

    // MARK: Address 2

    func testWithValidNonNONEAddress2() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(address2: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.address2)
      XCTAssertEqual(result.address2!, string)
    }

    func testWithValidNONEAddress2() throws {
      let data = jsonData(address2: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.address2)
    }

    func testWithEmptyAddress2() throws {
      let data = jsonData(address2: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.address2)
    }

    func assertDecodingErrorContext(_ context: DecodingError.Context, stringValue: String) {
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, stringValue)
      XCTAssertNil(context.underlyingError)
    }

    func testInvalidAddress2Type() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(address2: .present(element))
        assertTypeMismatch(from: data, "address2")
      }

    }

    func testMissingAddress2() throws {
      let data = jsonData(address2: .absent)
      assertMissing(from: data, "address2")
    }

    func testNullAddress2() throws {
      let data = jsonData(address2: .present(nil))
      assertNull(from: data, "address2")
    }

    func testWithAddress2PrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map { jsonData(address2: .present($0)) }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.address2)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(address2: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.address2)
        XCTAssertEqual(result.address2, "xyz")
      }

    }

    // MARK: City

    func testWithValidNonNONECity() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(city: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.city)
      XCTAssertEqual(result.city!, string)
    }

    func testWithValidNONECity() throws {
      let data = jsonData(city: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.city)
    }

    func testWithEmptyCity() throws {
      let data = jsonData(city: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.city)
    }

    func testInvalidCityType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(city: .present(element))
        assertTypeMismatch(from: data, "city")
      }

    }

    func testMissingCity() throws {
      let data = jsonData(city: .absent)
      assertMissing(from: data, "city")
    }

    func testNullCity() throws {
      let data = jsonData(city: .present(nil))
      assertNull(from: data, "city")
    }

    func testWithCityPrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map { jsonData(city: .present($0)) }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.city)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(city: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.city)
        XCTAssertEqual(result.city, "xyz")
      }

    }

    // MARK: State or Province

    func testWithValidNonNONEStateOrProvince() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(stateOrProvince: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.stateOrProvince)
      XCTAssertEqual(result.stateOrProvince!, string)
    }

    func testWithValidNONEStateOrProvince() throws {
      let data = jsonData(stateOrProvince: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.stateOrProvince)
    }

    func testWithEmptyStateOrProvince() throws {
      let data = jsonData(stateOrProvince: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.stateOrProvince)
    }

    func testInvalidStateOrProvinceType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(stateOrProvince: .present(element))
        assertTypeMismatch(from: data, "stateOrProvince")
      }

    }

    func testMissingStateOrProvince() throws {
      let data = jsonData(stateOrProvince: .absent)
      assertMissing(from: data, "stateOrProvince")
    }

    func testNullStateOrProvince() throws {
      let data = jsonData(stateOrProvince: .present(nil))
      assertNull(from: data, "stateOrProvince")
    }

    func testWithStateOrProvincePrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
        jsonData(stateOrProvince: .present($0))
      }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.stateOrProvince)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(stateOrProvince: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.stateOrProvince)
        XCTAssertEqual(result.stateOrProvince, "xyz")
      }

    }

    // MARK: Country

    func testWithValidNonNONECountry() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(country: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.country)
      XCTAssertEqual(result.country!, string)
    }

    func testWithValidNONECountry() throws {
      let data = jsonData(country: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.country)
    }

    func testWithEmptyCountry() throws {
      let data = jsonData(country: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.country)
    }

    func testInvalidCountryType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(country: .present(element))
        assertTypeMismatch(from: data, "country")
      }

    }

    func testMissingCountry() throws {
      let data = jsonData(country: .absent)
      assertMissing(from: data, "country")
    }

    func testNullCountry() throws {
      let data = jsonData(country: .present(nil))
      assertNull(from: data, "country")
    }

    func testWithCountryPrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
        jsonData(country: .present($0))
      }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.country)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(country: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.country)
        XCTAssertEqual(result.country, "xyz")
      }

    }

    // MARK: Zip code

    func testWithValidNonNONEZipCode() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(zipCode: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.zipCode)
      XCTAssertEqual(result.zipCode!, string)
    }

    func testWithValidNONEZipCode() throws {
      let data = jsonData(zipCode: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.zipCode)
    }

    func testWithEmptyZipCode() throws {
      let data = jsonData(zipCode: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.zipCode)
    }

    func testInvalidZipCodeType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(zipCode: .present(element))
        assertTypeMismatch(from: data, "zipCode")
      }

    }

    func testMissingZipCode() throws {
      let data = jsonData(zipCode: .absent)
      assertMissing(from: data, "zipCode")
    }

    func testNullZipCode() throws {
      let data = jsonData(zipCode: .present(nil))
      assertNull(from: data, "zipCode")
    }

    func testWithZipCodePrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
        jsonData(zipCode: .present($0))
      }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.zipCode)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(zipCode: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.zipCode)
        XCTAssertEqual(result.zipCode, "xyz")
      }

    }

  }

#endif
