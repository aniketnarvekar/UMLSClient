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

  final class DecodeUMLSCreatorContactTests: XCTestCase, XCTDecodingErrorAssertion {

    typealias Element = UMLSCreatorContact<UMLSPostalAddress>

    var jsonDecoder: JSONDecoder!
    var jsonEncoder: JSONEncoder!

    override func setUp() {
      self.jsonDecoder = .init()
      self.jsonEncoder = .init()
    }

    func jsonData(
      handle: JSONValue<Any> = .present(String.randomNumericString(of: 10)),
      name: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      title: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      organization: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      address1: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      address2: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      city: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      stateOrProvince: JSONValue<Any> = .present(String.randomNumericString(of: 2)),
      country: JSONValue<Any> = .present(String.randomNumericString(of: 5)),
      zipCode: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 5)),
      telephone: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      fax: JSONValue<Any> = .present(String.randomNumericString(of: 10)),
      email: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      url: JSONValue<Any> = .present("http://localhost:8080"),
      value: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10))
    ) -> Data {
      let dict = JSONSerializationDictionary.creatorContact(
        handle: handle,
        name: name,
        title: title,
        organization: organization,
        address1: address1,
        address2: address2,
        city: city,
        stateOrProvince: stateOrProvince,
        country: country,
        zipCode: zipCode,
        telephone: telephone,
        fax: fax,
        email: email,
        url: url,
        value: value)
      return try! JSONSerialization.data(withJSONObject: dict)
    }

    func assertTypeMismatch(from data: Data, _ string: String) {
      typeMismatch(from: data) { type, context in
        XCTAssert(type is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, string)
        XCTAssertNil(context.underlyingError)
      }
    }

    func assertMissing(from data: Data, _ string: String) {
      keyNotFound(from: data) { key, context in
        XCTAssertEqual(key.stringValue, string)
        XCTAssertTrue(context.codingPath.isEmpty)
        XCTAssertNil(context.underlyingError)
      }
    }

    func assertNull(from data: Data, _ string: String) {
      valueNotFound(from: data) { type, context in
        XCTAssert(type is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, string)
        XCTAssertNil(context.underlyingError)
      }
    }

    // MARK: HANDLE

    func testWithValidNonNONEHandle() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(handle: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.handle)
      XCTAssertEqual(result.handle!, string)
    }

    func testWithValidNONEHandle() throws {
      let data = jsonData(handle: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.handle)
    }

    func testWithEmptyHandle() throws {
      let data = jsonData(handle: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.handle)
    }

    func testInvalidHandleType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(handle: .present(element))
        assertTypeMismatch(from: data, "handle")
      }

    }

    func testMissingHandle() throws {
      let data = jsonData(handle: .absent)
      assertMissing(from: data, "handle")
    }

    func testNullHandle() throws {
      let data = jsonData(handle: .present(nil))
      assertNull(from: data, "handle")
    }

    func testWithHandlePrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
        jsonData(handle: .present($0))
      }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.handle)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(handle: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.handle)
        XCTAssertEqual(result.handle, "xyz")
      }

    }

    // MARK: name

    func testWithValidNonNONEName() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(name: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.name)
      XCTAssertEqual(result.name!, string)
    }

    func testWithValidNONEName() throws {
      let data = jsonData(name: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.name)
    }

    func testWithEmptyName() throws {
      let data = jsonData(name: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.name)
    }

    func testInvalidNameType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(name: .present(element))
        assertTypeMismatch(from: data, "name")
      }

    }

    func testMissingName() throws {
      let data = jsonData(name: .absent)
      assertMissing(from: data, "name")
    }

    func testNullName() throws {
      let data = jsonData(name: .present(nil))
      assertNull(from: data, "name")
    }

    func testWithNamePrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
        jsonData(name: .present($0))
      }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.name)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(name: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.name)
        XCTAssertEqual(result.name, "xyz")
      }

    }

    // MARK: title

    func testWithValidNonNONETitle() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(title: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.title)
      XCTAssertEqual(result.title!, string)
    }

    func testWithValidNONETitle() throws {
      let data = jsonData(title: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.title)
    }

    func testWithEmptyTitle() throws {
      let data = jsonData(title: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.title)
    }

    func testInvalidTitleType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(title: .present(element))
        assertTypeMismatch(from: data, "title")
      }

    }

    func testMissingTitle() throws {
      let data = jsonData(title: .absent)
      assertMissing(from: data, "title")
    }

    func testNullTitle() throws {
      let data = jsonData(title: .present(nil))
      assertNull(from: data, "title")
    }

    func testWithTitlePrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
        jsonData(title: .present($0))
      }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.title)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(title: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.title)
        XCTAssertEqual(result.title, "xyz")
      }

    }

    // MARK: organization

    func testWithValidNonNONEOrganization() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(organization: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.organization)
      XCTAssertEqual(result.organization!, string)
    }

    func testWithValidNONEOrganization() throws {
      let data = jsonData(organization: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.organization)
    }

    func testWithEmptyOrganization() throws {
      let data = jsonData(organization: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.organization)
    }

    func testInvalidOrganizationType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(organization: .present(element))
        assertTypeMismatch(from: data, "organization")
      }

    }

    func testMissingOrganization() throws {
      let data = jsonData(organization: .absent)
      assertMissing(from: data, "organization")
    }

    func testNullOrganization() throws {
      let data = jsonData(organization: .present(nil))
      assertNull(from: data, "organization")
    }

    func testWithOrganizationPrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
        jsonData(organization: .present($0))
      }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.organization)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(organization: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.organization)
        XCTAssertEqual(result.organization, "xyz")
      }
    }

    // MARK: telephone

    func testWithValidNonNONETelephone() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(telephone: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.telephone)
      XCTAssertEqual(result.telephone!, string)
    }

    func testWithValidNONETelephone() throws {
      let data = jsonData(telephone: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.telephone)
    }

    func testWithEmptyTelephone() throws {
      let data = jsonData(telephone: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.telephone)
    }

    func testInvalidTelephoneType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(telephone: .present(element))
        assertTypeMismatch(from: data, "telephone")
      }

    }

    func testMissingTelephone() throws {
      let data = jsonData(telephone: .absent)
      assertMissing(from: data, "telephone")
    }

    func testNullTelephone() throws {
      let data = jsonData(telephone: .present(nil))
      assertNull(from: data, "telephone")
    }

    func testWithTelephonePrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
        jsonData(telephone: .present($0))
      }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.telephone)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(telephone: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.telephone)
        XCTAssertEqual(result.telephone, "xyz")
      }

    }

    // MARK: fax

    func testWithValidNonNONEFax() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(fax: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.fax)
      XCTAssertEqual(result.fax!, string)
    }

    func testWithValidNONEFax() throws {
      let data = jsonData(fax: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.fax)
    }

    func testWithEmptyFax() throws {
      let data = jsonData(fax: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.fax)
    }

    func testInvalidFaxType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(fax: .present(element))
        assertTypeMismatch(from: data, "fax")
      }

    }

    func testMissingFax() throws {
      let data = jsonData(fax: .absent)
      assertMissing(from: data, "fax")
    }

    func testNullFax() throws {
      let data = jsonData(fax: .present(nil))
      assertNull(from: data, "fax")
    }

    func testWithFaxPrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
        jsonData(fax: .present($0))
      }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.fax)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(fax: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.fax)
        XCTAssertEqual(result.fax, "xyz")
      }

    }

    // MARK: email

    func testWithValidNonNONEEmail() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(email: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.email)
      XCTAssertEqual(result.email!, string)
    }

    func testWithValidNONEEmail() throws {
      let data = jsonData(email: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.email)
    }

    func testWithEmptyEmail() throws {
      let data = jsonData(email: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.email)
    }

    func testInvalidEmailType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(email: .present(element))
        assertTypeMismatch(from: data, "email")
      }

    }

    func testMissingEmail() throws {
      let data = jsonData(email: .absent)
      assertMissing(from: data, "email")
    }

    func testNullEmail() throws {
      let data = jsonData(email: .present(nil))
      assertNull(from: data, "email")
    }

    func testWithEmailPrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
        jsonData(email: .present($0))
      }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.email)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(email: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.email)
        XCTAssertEqual(result.email, "xyz")
      }

    }

    // MARK: value

    func testWithValidValue() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(value: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.value)
      XCTAssertEqual(result.value, string)
    }

    func testWithEmptyValue() throws {
      let data = jsonData(value: .present(""))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "value")
        XCTAssertEqual(context.debugDescription, "Empty \"value\" key value.")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testInvalidValueType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(value: .present(element))
        assertTypeMismatch(from: data, "value")
      }

    }

    func testMissingValue() throws {
      let data = jsonData(value: .absent)
      assertMissing(from: data, "value")
    }

    func testNullValue() throws {
      let data = jsonData(value: .present(nil))
      assertNull(from: data, "value")
    }

    // MARK: url

    func testWithValidUrl() throws {
      let string = "https://google.com/"
      let data = jsonData(url: .present(string))
      let object = try toObject(from: data)
      XCTAssertNotNil(object.url)
      XCTAssertEqual(object.url!.description, string)
    }

    func testWithNONEUrl() throws {
      let data = jsonData(url: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.url)
    }

    func testWithEmptyURL() throws {
      let data = jsonData(url: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.url)
    }

    func testInvalidUrlType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(url: .present(element))
        assertTypeMismatch(from: data, "url")
      }

    }

    func testMissingUrl() throws {
      let data = jsonData(url: .absent)
      assertMissing(from: data, "url")
    }

    func testNullUrl() throws {
      let data = jsonData(url: .present(nil))
      assertNull(from: data, "url")
    }

  }

  final class UMLSContactInformationTypeObjectTests: XCTestCase,
    XCTDecodingErrorAssertion
  {
    typealias Element = UMLSContactInformationTypeObject<
      UMLSCreatorContact<UMLSPostalAddress>
    >

    var jsonEncoder: JSONEncoder!
    var jsonDecoder: JSONDecoder!

    func jsonData(
      classType: JSONValue<Any> = .present("ContactInformation")
    ) -> Data {
      let dict = JSONSerializationDictionary.creatorContact(
        classType: classType
      )
      return try! JSONSerialization.data(withJSONObject: dict)
    }

    override func setUp() {
      self.jsonDecoder = .init()
      self.jsonEncoder = .init()
    }

    func assertTypeMismatch(from data: Data, _ string: String) {
      typeMismatch(from: data) { type, context in
        XCTAssert(type is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, string)
        XCTAssertNil(context.underlyingError)
      }
    }

    func assertMissing(from data: Data, _ string: String) {
      keyNotFound(from: data) { key, context in
        XCTAssertEqual(key.stringValue, string)
        XCTAssertTrue(context.codingPath.isEmpty)
        XCTAssertNil(context.underlyingError)
      }
    }

    func assertNull(from data: Data, _ string: String) {
      valueNotFound(from: data) { type, context in
        XCTAssert(type is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, string)
        XCTAssertNil(context.underlyingError)
      }
    }

    func testWithValidClassType() throws {
      let data = jsonData()
      XCTAssertNoThrow(try toObject(from: data))
    }

    func testWithInvalidClassType() throws {
      let strings: [String] = [
        "", .randomBoolString(), .randomNumericString(of: 10), .randomAlphaNumericString(of: 10),
      ]
      for string in strings {
        let data = jsonData(classType: .present(string))
        dataCorrupted(from: data) { context in
          XCTAssertFalse(context.codingPath.isEmpty)
          XCTAssertEqual(context.codingPath[0].stringValue, "classType")
          XCTAssertNil(context.underlyingError)
        }
      }
    }

    func testInvalidClassTypeType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(classType: .present(element))
        assertTypeMismatch(from: data, "classType")
      }

    }

    func testMissingClassType() throws {
      let data = jsonData(classType: .absent)
      assertMissing(from: data, "classType")
    }

    func testNullClassType() throws {
      let data = jsonData(classType: .present(nil))
      assertNull(from: data, "classType")
    }

    func testWithClassTypePrefixSuffixWhitespaces() throws {
      let data = [" ContactInformation", "ContactInformation ", " ContactInformation "].map {
        jsonData(classType: .present($0))
      }

      for data in data {
        XCTAssertNoThrow(try toObject(from: data))
      }
    }
  }

  final class UMLSLicenseContentTests: XCTestCase, XCTDecodingErrorAssertion {

    typealias Element = UMLSLicenseContact<UMLSPostalAddress>

    var jsonDecoder: JSONDecoder!
    var jsonEncoder: JSONEncoder!

    override func setUp() {
      self.jsonDecoder = .init()
      self.jsonEncoder = .init()
    }

    func jsonData(
      handle: JSONValue<Any> = .present(String.randomNumericString(of: 10)),
      name: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      title: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      organization: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      address1: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      address2: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      city: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      stateOrProvince: JSONValue<Any> = .present(String.randomNumericString(of: 2)),
      country: JSONValue<Any> = .present(String.randomNumericString(of: 5)),
      zipCode: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 5)),
      telephone: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      fax: JSONValue<Any> = .present(String.randomNumericString(of: 10)),
      email: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      url: JSONValue<Any> = .present("http://localhost:8080"),
      value: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10))
    ) -> Data {
      let dict = JSONSerializationDictionary.creatorContact(
        handle: handle,
        name: name,
        title: title,
        organization: organization,
        address1: address1,
        address2: address2,
        city: city,
        stateOrProvince: stateOrProvince,
        country: country,
        zipCode: zipCode,
        telephone: telephone,
        fax: fax,
        email: email,
        url: url,
        value: value)
      return try! JSONSerialization.data(withJSONObject: dict)
    }

    func assertTypeMismatch(from data: Data, _ string: String) {
      typeMismatch(from: data) { type, context in
        XCTAssert(type is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, string)
        XCTAssertNil(context.underlyingError)
      }
    }

    func assertMissing(from data: Data, _ string: String) {
      keyNotFound(from: data) { key, context in
        XCTAssertEqual(key.stringValue, string)
        XCTAssertTrue(context.codingPath.isEmpty)
        XCTAssertNil(context.underlyingError)
      }
    }

    func assertNull(from data: Data, _ string: String) {
      valueNotFound(from: data) { type, context in
        XCTAssert(type is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, string)
        XCTAssertNil(context.underlyingError)
      }
    }

    // MARK: HANDLE

    func testWithValidNonNONEHandle() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(handle: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.handle)
      XCTAssertEqual(result.handle!, string)
    }

    func testWithValidNONEHandle() throws {
      let data = jsonData(handle: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.handle)
    }

    func testWithEmptyHandle() throws {
      let data = jsonData(handle: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.handle)
    }

    func testInvalidHandleType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(handle: .present(element))
        assertTypeMismatch(from: data, "handle")
      }

    }

    func testMissingHandle() throws {
      let data = jsonData(handle: .absent)
      assertMissing(from: data, "handle")
    }

    func testNullHandle() throws {
      let data = jsonData(handle: .present(nil))
      assertNull(from: data, "handle")
    }

    func testWithHandlePrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
        jsonData(handle: .present($0))
      }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.handle)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(handle: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.handle)
        XCTAssertEqual(result.handle, "xyz")
      }

    }

    // MARK: name

    func testWithValidNonNONEName() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(name: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.name)
      XCTAssertEqual(result.name!, string)
    }

    func testWithValidNONEName() throws {
      let data = jsonData(name: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.name)
    }

    func testWithEmptyName() throws {
      let data = jsonData(name: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.name)
    }

    func testInvalidNameType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(name: .present(element))
        assertTypeMismatch(from: data, "name")
      }

    }

    func testMissingName() throws {
      let data = jsonData(name: .absent)
      assertMissing(from: data, "name")
    }

    func testNullName() throws {
      let data = jsonData(name: .present(nil))
      assertNull(from: data, "name")
    }

    func testWithNamePrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
        jsonData(name: .present($0))
      }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.name)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(name: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.name)
        XCTAssertEqual(result.name, "xyz")
      }

    }

    // MARK: title

    func testWithValidNonNONETitle() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(title: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.title)
      XCTAssertEqual(result.title!, string)
    }

    func testWithValidNONETitle() throws {
      let data = jsonData(title: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.title)
    }

    func testWithEmptyTitle() throws {
      let data = jsonData(title: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.title)
    }

    func testInvalidTitleType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(title: .present(element))
        assertTypeMismatch(from: data, "title")
      }

    }

    func testMissingTitle() throws {
      let data = jsonData(title: .absent)
      assertMissing(from: data, "title")
    }

    func testNullTitle() throws {
      let data = jsonData(title: .present(nil))
      assertNull(from: data, "title")
    }

    func testWithTitlePrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
        jsonData(title: .present($0))
      }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.title)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(title: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.title)
        XCTAssertEqual(result.title, "xyz")
      }

    }

    // MARK: organization

    func testWithValidNonNONEOrganization() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(organization: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.organization)
      XCTAssertEqual(result.organization!, string)
    }

    func testWithValidNONEOrganization() throws {
      let data = jsonData(organization: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.organization)
    }

    func testWithEmptyOrganization() throws {
      let data = jsonData(organization: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.organization)
    }

    func testInvalidOrganizationType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(organization: .present(element))
        assertTypeMismatch(from: data, "organization")
      }

    }

    func testMissingOrganization() throws {
      let data = jsonData(organization: .absent)
      assertMissing(from: data, "organization")
    }

    func testNullOrganization() throws {
      let data = jsonData(organization: .present(nil))
      assertNull(from: data, "organization")
    }

    func testWithOrganizationPrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
        jsonData(organization: .present($0))
      }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.organization)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(organization: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.organization)
        XCTAssertEqual(result.organization, "xyz")
      }
    }

    // MARK: telephone

    func testWithValidNonNONETelephone() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(telephone: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.telephone)
      XCTAssertEqual(result.telephone!, string)
    }

    func testWithValidNONETelephone() throws {
      let data = jsonData(telephone: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.telephone)
    }

    func testWithEmptyTelephone() throws {
      let data = jsonData(telephone: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.telephone)
    }

    func testInvalidTelephoneType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(telephone: .present(element))
        assertTypeMismatch(from: data, "telephone")
      }

    }

    func testMissingTelephone() throws {
      let data = jsonData(telephone: .absent)
      assertMissing(from: data, "telephone")
    }

    func testNullTelephone() throws {
      let data = jsonData(telephone: .present(nil))
      assertNull(from: data, "telephone")
    }

    func testWithTelephonePrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
        jsonData(telephone: .present($0))
      }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.telephone)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(telephone: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.telephone)
        XCTAssertEqual(result.telephone, "xyz")
      }

    }

    // MARK: fax

    func testWithValidNonNONEFax() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(fax: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.fax)
      XCTAssertEqual(result.fax!, string)
    }

    func testWithValidNONEFax() throws {
      let data = jsonData(fax: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.fax)
    }

    func testWithEmptyFax() throws {
      let data = jsonData(fax: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.fax)
    }

    func testInvalidFaxType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(fax: .present(element))
        assertTypeMismatch(from: data, "fax")
      }

    }

    func testMissingFax() throws {
      let data = jsonData(fax: .absent)
      assertMissing(from: data, "fax")
    }

    func testNullFax() throws {
      let data = jsonData(fax: .present(nil))
      assertNull(from: data, "fax")
    }

    func testWithFaxPrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
        jsonData(fax: .present($0))
      }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.fax)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(fax: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.fax)
        XCTAssertEqual(result.fax, "xyz")
      }

    }

    // MARK: email

    func testWithValidNonNONEEmail() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(email: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.email)
      XCTAssertEqual(result.email!, string)
    }

    func testWithValidNONEEmail() throws {
      let data = jsonData(email: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.email)
    }

    func testWithEmptyEmail() throws {
      let data = jsonData(email: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.email)
    }

    func testInvalidEmailType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(email: .present(element))
        assertTypeMismatch(from: data, "email")
      }

    }

    func testMissingEmail() throws {
      let data = jsonData(email: .absent)
      assertMissing(from: data, "email")
    }

    func testNullEmail() throws {
      let data = jsonData(email: .present(nil))
      assertNull(from: data, "email")
    }

    func testWithEmailPrefixSuffixWhitespaces() throws {
      var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
        jsonData(email: .present($0))
      }

      for data in data {
        let result = try toObject(from: data)
        XCTAssertNil(result.email)
      }

      data = [" xyz", "xyz  ", "  xyz "].map { jsonData(email: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.email)
        XCTAssertEqual(result.email, "xyz")
      }

    }

    // MARK: value

    func testWithValidValue() throws {
      let string = String.randomAlphaNumericString(of: 5)
      let data = jsonData(value: .present(string))
      let result = try toObject(from: data)
      XCTAssertNotNil(result.value)
      XCTAssertEqual(result.value, string)
    }

    func testWithEmptyValue() throws {
      let data = jsonData(value: .present(""))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "value")
        XCTAssertEqual(context.debugDescription, "Empty \"value\" key value.")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testInvalidValueType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(value: .present(element))
        assertTypeMismatch(from: data, "value")
      }

    }

    func testMissingValue() throws {
      let data = jsonData(value: .absent)
      assertMissing(from: data, "value")
    }

    func testNullValue() throws {
      let data = jsonData(value: .present(nil))
      assertNull(from: data, "value")
    }

    // MARK: url

    func testWithValidUrl() throws {
      let string = "https://google.com/"
      let data = jsonData(url: .present(string))
      let object = try toObject(from: data)
      XCTAssertNotNil(object.url)
      XCTAssertEqual(object.url!.description, string)
    }

    func testWithNONEUrl() throws {
      let data = jsonData(url: .present(String.none))
      let result = try toObject(from: data)
      XCTAssertNil(result.url)
    }

    func testWithEmptyURL() throws {
      let data = jsonData(url: .present(""))
      let result = try toObject(from: data)
      XCTAssertNil(result.url)
    }

    func testInvalidUrlType() throws {
      let list: [Any] = [
        Int.random(in: Int.min...Int.max),
        [],
        Float.random(in: 0.0..<10.0),
        Bool.random(),
        [:],
      ]
      for element in list {
        let data = jsonData(url: .present(element))
        assertTypeMismatch(from: data, "url")
      }

    }

    func testMissingUrl() throws {
      let data = jsonData(url: .absent)
      assertMissing(from: data, "url")
    }

    func testNullUrl() throws {
      let data = jsonData(url: .present(nil))
      assertNull(from: data, "url")
    }

  }

  final class UMLSSourceVocabularyInfoTests: XCTestCase, XCTDecodingErrorAssertion {

    typealias Element = UMLSSourceVocabularyInfo<
      UMLSLanguageInfo, UMLSCreatorContact<UMLSPostalAddress>, UMLSLicenseContact<UMLSPostalAddress>
    >

    var jsonDecoder: JSONDecoder!
    var jsonEncoder: JSONEncoder!

    override func setUp() {
      self.jsonDecoder = .init()
      self.jsonEncoder = .init()
    }

    func jsonData(
      classType: JSONValue<Any> = .present("RootSource"),
      abbreviation: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      expandedForm: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      family: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      language: JSONValue<Any> = .present(JSONSerializationDictionary.languageInfo()),
      restrictionLevel: JSONValue<Any> = .present(UInt.random(in: 0..<10)),
      acquisitionContact: JSONValue<Any> = .present(
        ["NONE", .randomAlphaNumericString(of: 10)].randomElement()!),
      contentContact: JSONValue<Any> = .present(JSONSerializationDictionary.creatorContact()),
      licenseContact: JSONValue<Any> = .present(JSONSerializationDictionary.creatorContact()),
      contextType: JSONValue<Any> = .present(UMLSContextType.random().rawValue),
      shortName: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      hierarchicalName: JSONValue<Any> = .present(
        ["NONE", .randomAlphaNumericString(of: 10)].randomElement()!),
      preferredName: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      synonymousNames: JSONValue<Any> = .present(
        ["NONE", .randomAlphaNumericString(of: 10)].randomElement()!)
    ) -> Data {
      let dictionary = JSONSerializationDictionary.sourceVocabulary(
        classType: classType, abbreviation: abbreviation, expanededForm: expandedForm,
        family: family, language: language, restrictionLevel: restrictionLevel,
        acquisitionContact: acquisitionContact, contentContact: contentContact,
        licenseContact: licenseContact, contextType: contextType, shortName: shortName,
        hierarchicalName: hierarchicalName, preferredName: preferredName,
        synonymousNames: synonymousNames)
      return try! JSONSerialization.data(withJSONObject: dictionary)
    }

    func assertTypeMismatch(from data: Data, _ string: String) {
      typeMismatch(from: data) { type, context in
        XCTAssert(type is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, string)
        XCTAssertNil(context.underlyingError)
      }
    }

    func assertMissing(from data: Data, _ string: String) {
      keyNotFound(from: data) { key, context in
        XCTAssertEqual(key.stringValue, string)
        XCTAssertTrue(context.codingPath.isEmpty)
        XCTAssertNil(context.underlyingError)
      }
    }

    func assertNull(from data: Data, _ string: String) {
      valueNotFound(from: data) { type, context in
        XCTAssert(type is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, string)
        XCTAssertNil(context.underlyingError)
      }
    }

    // MARK: Abbreviation

    func testWithValidAbbreviation() throws {
      let string = String.randomAlphaNumericString(of: 10)
      let data = jsonData(abbreviation: .present(string))
      let result = try toObject(from: data).abbreviation
      XCTAssertFalse(result.isEmpty)
      XCTAssertEqual(result, string)
    }

    func testWithNONEAbbreviation() throws {
      let data = jsonData(abbreviation: .present(String.none))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "abbreviation")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testWithEmptyAbbreviation() throws {
      let data = jsonData(abbreviation: .present(""))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "abbreviation")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testWithInvalidAbbreviationTypeJSON() throws {
      let values: [Encodable] = [
        Int.random(in: Int.min...Int.max),
        Array<Int>.init(),
        (0..<10).map { $0 },
        Bool.random(),
      ]

      let data =
        values
        .map {
          jsonData(abbreviation: .present($0))
        }

      for data in data {
        XCTAssertThrowsError(try toObject(from: data))
        typeMismatch(from: data) { typ, context in
          XCTAssert(typ is String.Type)
          XCTAssertFalse(context.codingPath.isEmpty)
          XCTAssertEqual(context.codingPath[0].stringValue, "abbreviation")
          XCTAssertNil(context.underlyingError)
        }
      }
    }

    func testMissingAbbreviation() throws {
      let data = jsonData(abbreviation: .absent)
      assertMissing(from: data, "abbreviation")
    }

    func testNullAbbreviation() throws {
      let data = jsonData(abbreviation: .present(nil))
      assertNull(from: data, "abbreviation")
    }

    func testWithAbbreviationPrefixSuffixWhitespaces() throws {
      let data = [" xyz", "xyz  ", "  xyz "].map { jsonData(abbreviation: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.abbreviation)
        XCTAssertEqual(result.abbreviation, "xyz")
      }
    }

    // MARK: expandedForm

    func testWithValidExpandedForm() throws {
      let string = String.randomAlphaNumericString(of: 10)
      let data = jsonData(expandedForm: .present(string))
      let result = try toObject(from: data).expandedForm
      XCTAssertFalse(result.isEmpty)
      XCTAssertEqual(result, string)
    }

    func testWithNONEExpandedForm() throws {
      let data = jsonData(expandedForm: .present(String.none))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "expandedForm")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testWithEmptyExpandedForm() throws {
      let data = jsonData(expandedForm: .present(""))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "expandedForm")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testWithInvalidExpandedFormTypeJSON() throws {
      let values: [Encodable] = [
        Int.random(in: Int.min...Int.max),
        Array<Int>.init(),
        (0..<10).map { $0 },
        Bool.random(),
      ]

      let data =
        values
        .map {
          jsonData(expandedForm: .present($0))
        }

      for data in data {
        XCTAssertThrowsError(try toObject(from: data))
        typeMismatch(from: data) { typ, context in
          XCTAssert(typ is String.Type)
          XCTAssertFalse(context.codingPath.isEmpty)
          XCTAssertEqual(context.codingPath[0].stringValue, "expandedForm")
          XCTAssertNil(context.underlyingError)
        }
      }
    }

    func testMissingExpandedForm() throws {
      let data = jsonData(expandedForm: .absent)
      assertMissing(from: data, "expandedForm")
    }

    func testNullExpandedForm() throws {
      let data = jsonData(expandedForm: .present(nil))
      assertNull(from: data, "expandedForm")
    }

    func testWithExpandedFormPrefixSuffixWhitespaces() throws {
      let data = [" xyz", "xyz  ", "  xyz "].map { jsonData(expandedForm: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.expandedForm)
        XCTAssertEqual(result.expandedForm, "xyz")
      }
    }

    // MARK: family

    func testWithValidFamily() throws {
      let string = String.randomAlphaNumericString(of: 10)
      let data = jsonData(family: .present(string))
      let result = try toObject(from: data).family
      XCTAssertFalse(result.isEmpty)
      XCTAssertEqual(result, string)
    }

    func testWithNONEFamily() throws {
      let data = jsonData(family: .present(String.none))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "family")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testWithEmptyFamily() throws {
      let data = jsonData(family: .present(""))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "family")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testWithInvalidFamilyTypeJSON() throws {
      let values: [Encodable] = [
        Int.random(in: Int.min...Int.max),
        Array<Int>.init(),
        (0..<10).map { $0 },
        Bool.random(),
      ]

      let data =
        values
        .map {
          jsonData(family: .present($0))
        }

      for data in data {
        XCTAssertThrowsError(try toObject(from: data))
        typeMismatch(from: data) { typ, context in
          XCTAssert(typ is String.Type)
          XCTAssertFalse(context.codingPath.isEmpty)
          XCTAssertEqual(context.codingPath[0].stringValue, "family")
          XCTAssertNil(context.underlyingError)
        }
      }
    }

    func testMissingFamily() throws {
      let data = jsonData(family: .absent)
      assertMissing(from: data, "family")
    }

    func testNullFamily() throws {
      let data = jsonData(family: .present(nil))
      assertNull(from: data, "family")
    }

    func testWithFamilyPrefixSuffixWhitespaces() throws {
      let data = [" xyz", "xyz  ", "  xyz "].map { jsonData(family: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.family)
        XCTAssertEqual(result.family, "xyz")
      }
    }

    // MARK: shortName

    func testWithValidShortName() throws {
      let string = String.randomAlphaNumericString(of: 10)
      let data = jsonData(shortName: .present(string))
      let result = try toObject(from: data).shortName
      XCTAssertFalse(result.isEmpty)
      XCTAssertEqual(result, string)
    }

    func testWithNONEShortName() throws {
      let data = jsonData(shortName: .present(String.none))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "shortName")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testWithEmptyShortName() throws {
      let data = jsonData(shortName: .present(""))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "shortName")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testWithInvalidShortNameTypeJSON() throws {
      let values: [Encodable] = [
        Int.random(in: Int.min...Int.max),
        Array<Int>.init(),
        (0..<10).map { $0 },
        Bool.random(),
      ]

      let data =
        values
        .map {
          jsonData(shortName: .present($0))
        }

      for data in data {
        XCTAssertThrowsError(try toObject(from: data))
        typeMismatch(from: data) { typ, context in
          XCTAssert(typ is String.Type)
          XCTAssertFalse(context.codingPath.isEmpty)
          XCTAssertEqual(context.codingPath[0].stringValue, "shortName")
          XCTAssertNil(context.underlyingError)
        }
      }
    }

    func testMissingShortName() throws {
      let data = jsonData(shortName: .absent)
      assertMissing(from: data, "shortName")
    }

    func testNullShortName() throws {
      let data = jsonData(shortName: .present(nil))
      assertNull(from: data, "shortName")
    }

    func testWithShortNamePrefixSuffixWhitespaces() throws {
      let data = [" xyz", "xyz  ", "  xyz "].map { jsonData(shortName: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.shortName)
        XCTAssertEqual(result.shortName, "xyz")
      }
    }

    // MARK: preferredName

    func testWithValidPreferredName() throws {
      let string = String.randomAlphaNumericString(of: 10)
      let data = jsonData(preferredName: .present(string))
      let result = try toObject(from: data).preferredName
      XCTAssertFalse(result.isEmpty)
      XCTAssertEqual(result, string)
    }

    func testWithNONEPreferredName() throws {
      let data = jsonData(preferredName: .present(String.none))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "preferredName")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testWithEmptyPreferredName() throws {
      let data = jsonData(preferredName: .present(""))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "preferredName")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testWithInvalidPreferredNameTypeJSON() throws {
      let values: [Encodable] = [
        Int.random(in: Int.min...Int.max),
        Array<Int>.init(),
        (0..<10).map { $0 },
        Bool.random(),
      ]

      let data =
        values
        .map {
          jsonData(preferredName: .present($0))
        }

      for data in data {
        XCTAssertThrowsError(try toObject(from: data))
        typeMismatch(from: data) { typ, context in
          XCTAssert(typ is String.Type)
          XCTAssertFalse(context.codingPath.isEmpty)
          XCTAssertEqual(context.codingPath[0].stringValue, "preferredName")
          XCTAssertNil(context.underlyingError)
        }
      }
    }

    func testMissingPreferredName() throws {
      let data = jsonData(preferredName: .absent)
      assertMissing(from: data, "preferredName")
    }

    func testNullPreferredName() throws {
      let data = jsonData(preferredName: .present(nil))
      assertNull(from: data, "preferredName")
    }

    func testWithPreferredNamePrefixSuffixWhitespaces() throws {
      let data = [" xyz", "xyz  ", "  xyz "].map { jsonData(preferredName: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.preferredName)
        XCTAssertEqual(result.preferredName, "xyz")
      }
    }

    // MARK: acquisitionContact

    func testWithValidAcquisitionContact() throws {
      let string = String.randomAlphaNumericString(of: 10)
      let data = jsonData(acquisitionContact: .present(string))
      let result = try toObject(from: data).acquisitionContact
      XCTAssertEqual(result, string)
    }

    func testWithNONEAcquisitionContact() throws {
      let data = jsonData(acquisitionContact: .present(String.none))
      let result = try toObject(from: data).acquisitionContact
      XCTAssertNil(result)
    }

    func testWithEmptyAcquisitionContact() throws {
      let data = jsonData(acquisitionContact: .present(""))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "acquisitionContact")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testWithInvalidAcquisitionContactTypeJSON() throws {
      let values: [Encodable] = [
        Int.random(in: Int.min...Int.max),
        Array<Int>.init(),
        (0..<10).map { $0 },
        Bool.random(),
      ]

      let data =
        values
        .map {
          jsonData(acquisitionContact: .present($0))
        }

      for data in data {
        XCTAssertThrowsError(try toObject(from: data))
        typeMismatch(from: data) { typ, context in
          XCTAssert(typ is String.Type)
          XCTAssertFalse(context.codingPath.isEmpty)
          XCTAssertEqual(context.codingPath[0].stringValue, "acquisitionContact")
          XCTAssertNil(context.underlyingError)
        }
      }
    }

    func testMissingAcquisitionContact() throws {
      let data = jsonData(acquisitionContact: .absent)
      assertMissing(from: data, "acquisitionContact")
    }

    func testNullAcquisitionContact() throws {
      let data = jsonData(acquisitionContact: .present(nil))
      assertNull(from: data, "acquisitionContact")
    }

    func testWithAcquisitionContactPrefixSuffixWhitespaces() throws {
      let data = [" xyz", "xyz  ", "  xyz "].map { jsonData(acquisitionContact: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.acquisitionContact)
        XCTAssertEqual(result.acquisitionContact, "xyz")
      }
    }

    // MARK: hierarchicalName

    func testWithValidHierarchicalName() throws {
      let string = String.randomAlphaNumericString(of: 10)
      let data = jsonData(hierarchicalName: .present(string))
      let result = try toObject(from: data).hierarchicalName
      XCTAssertEqual(result, string)
    }

    func testWithNONEHierarchicalName() throws {
      let data = jsonData(hierarchicalName: .present(String.none))
      let result = try toObject(from: data).hierarchicalName
      XCTAssertNil(result)
    }

    func testWithEmptyHierarchicalName() throws {
      let data = jsonData(hierarchicalName: .present(""))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "hierarchicalName")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testWithInvalidHierarchicalNameTypeJSON() throws {
      let values: [Encodable] = [
        Int.random(in: Int.min...Int.max),
        Array<Int>.init(),
        (0..<10).map { $0 },
        Bool.random(),
      ]

      let data =
        values
        .map {
          jsonData(hierarchicalName: .present($0))
        }

      for data in data {
        XCTAssertThrowsError(try toObject(from: data))
        typeMismatch(from: data) { typ, context in
          XCTAssert(typ is String.Type)
          XCTAssertFalse(context.codingPath.isEmpty)
          XCTAssertEqual(context.codingPath[0].stringValue, "hierarchicalName")
          XCTAssertNil(context.underlyingError)
        }
      }
    }

    func testMissingHierarchicalName() throws {
      let data = jsonData(hierarchicalName: .absent)
      assertMissing(from: data, "hierarchicalName")
    }

    func testNullHierarchicalName() throws {
      let data = jsonData(hierarchicalName: .present(nil))
      assertNull(from: data, "hierarchicalName")
    }

    func testWithHierarchicalNamePrefixSuffixWhitespaces() throws {
      let data = [" xyz", "xyz  ", "  xyz "].map { jsonData(hierarchicalName: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.hierarchicalName)
        XCTAssertEqual(result.hierarchicalName, "xyz")
      }
    }

    // MARK: synonymousNames

    func testWithValidSynonymousNames() throws {
      let string = String.randomAlphaNumericString(of: 10)
      let data = jsonData(synonymousNames: .present(string))
      let result = try toObject(from: data).synonymousNames
      XCTAssertEqual(result, string)
    }

    func testWithNONESynonymousNames() throws {
      let data = jsonData(synonymousNames: .present(String.none))
      let result = try toObject(from: data).synonymousNames
      XCTAssertNil(result)
    }

    func testWithEmptySynonymousNames() throws {
      let data = jsonData(synonymousNames: .present(""))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "synonymousNames")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testWithInvalidSynonymousNamesTypeJSON() throws {
      let values: [Encodable] = [
        Int.random(in: Int.min...Int.max),
        Array<Int>.init(),
        (0..<10).map { $0 },
        Bool.random(),
      ]

      let data =
        values
        .map {
          jsonData(synonymousNames: .present($0))
        }

      for data in data {
        XCTAssertThrowsError(try toObject(from: data))
        typeMismatch(from: data) { typ, context in
          XCTAssert(typ is String.Type)
          XCTAssertFalse(context.codingPath.isEmpty)
          XCTAssertEqual(context.codingPath[0].stringValue, "synonymousNames")
          XCTAssertNil(context.underlyingError)
        }
      }
    }

    func testMissingSynonymousNames() throws {
      let data = jsonData(synonymousNames: .absent)
      assertMissing(from: data, "synonymousNames")
    }

    func testNullSynonymousNames() throws {
      let data = jsonData(synonymousNames: .present(nil))
      assertNull(from: data, "synonymousNames")
    }

    func testWithSynonymousNamesPrefixSuffixWhitespaces() throws {
      let data = [" xyz", "xyz  ", "  xyz "].map { jsonData(synonymousNames: .present($0)) }
      for data in data {
        let result = try toObject(from: data)
        XCTAssertNotNil(result.synonymousNames)
        XCTAssertEqual(result.synonymousNames, "xyz")
      }
    }

    // MARK: restrictionLevel

    func testWithValidRestrictionLevel() throws {
      let string = Int8.random(in: 0...Int8.max)
      let data = jsonData(restrictionLevel: .present(string))
      let result = try toObject(from: data).restrictionLevel
      XCTAssertGreaterThanOrEqual(result, 0)
    }

    func testWithNegativeRestrictionLevel() throws {
      let data = jsonData(restrictionLevel: .present(Int.random(in: Int.min..<0)))
      dataCorrupted(from: data) { context in
        XCTAssertTrue(context.codingPath.isEmpty)
        XCTAssertNotNil(context.underlyingError)
        let error = context.underlyingError! as NSError
        XCTAssertEqual(error.domain, NSCocoaErrorDomain)
        XCTAssertEqual(error.code, 3840)
      }
    }

    func testWithInvalidRestrictionLevelTypeJSON() throws {
      let values: [Encodable] = [
        Bool.random(),
        String.randomAlphaNumericString(of: 10)
      ]

      let data =
        values
        .map {
          jsonData(restrictionLevel: .present($0))
        }

      for data in data {
        XCTAssertThrowsError(try toObject(from: data))
        typeMismatch(from: data) { typ, context in
          XCTAssert(typ is UInt8.Type)
          XCTAssertFalse(context.codingPath.isEmpty)
          XCTAssertEqual(context.codingPath[0].stringValue, "restrictionLevel")
          XCTAssertNil(context.underlyingError)
        }
      }
    }

    func testMissingRestrictionLevel() throws {
      let data = jsonData(restrictionLevel: .absent)
      assertMissing(from: data, "restrictionLevel")
    }

    func testNullRestrictionLevel() throws {
      let data = jsonData(restrictionLevel: .present(nil))
      valueNotFound(from: data) { type, context in
        XCTAssert(type is UInt8.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "restrictionLevel")
        XCTAssertNil(context.underlyingError)
      }
    }

    // MARK: language

    func testWithValidLangauge() throws {
      let dictionary = JSONSerializationDictionary.languageInfo()
      let data = jsonData(language: .present(dictionary))
      XCTAssertNoThrow(try toObject(from: data))
    }

    func testWithInvalidLanguageTypeJSON() throws {
      let values: [Encodable] = [
        Int.random(in: Int.min...Int.max),
        Array<Int>.init(),
        (0..<10).map { $0 },
        Bool.random(),
      ]

      let data =
        values
        .map {
          jsonData(language: .present($0))
        }

      for data in data {
        typeMismatch(from: data) { typ, context in
          XCTAssert(typ is [String:Any].Type)
          XCTAssertFalse(context.codingPath.isEmpty)
          XCTAssertEqual(context.codingPath[0].stringValue, "language")
          XCTAssertNil(context.underlyingError)
        }
      }
    }

    func testMissingLanguage() throws {
      let data = jsonData(language: .absent)
      assertMissing(from: data, "language")
    }

    func testNullLanguage() throws {
      let data = jsonData(language: .present(nil))
      valueNotFound(from: data) { type, context in
        print(type, context)
        XCTAssert(type is [String:Any].Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "language")
        XCTAssertNil(context.underlyingError)
      }
    }

    // MARK: contentContact

    func testWithValidContentContact() throws {
      let dictionary = JSONSerializationDictionary.creatorContact()
      let data = jsonData(contentContact: .present(dictionary))
      XCTAssertNoThrow(try toObject(from: data))
    }

    func testWithInvalidContentContactTypeJSON() throws {
      let values: [Encodable] = [
        Int.random(in: Int.min...Int.max),
        Array<Int>.init(),
        (0..<10).map { $0 },
        Bool.random(),
      ]

      let data =
        values
        .map {
          jsonData(contentContact: .present($0))
        }

      for data in data {
        typeMismatch(from: data) { typ, context in
          XCTAssert(typ is [String:Any].Type)
          XCTAssertFalse(context.codingPath.isEmpty)
          XCTAssertEqual(context.codingPath[0].stringValue, "contentContact")
          XCTAssertNil(context.underlyingError)
        }
      }
    }

    func testMissingContentContact() throws {
      let data = jsonData(contentContact: .absent)
      assertMissing(from: data, "contentContact")
    }

    func testNullContentContact() throws {
      let data = jsonData(contentContact: .present(nil))
      valueNotFound(from: data) { type, context in
        print(type, context)
        XCTAssert(type is [String:Any].Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "contentContact")
        XCTAssertNil(context.underlyingError)
      }
    }

    // MARK: licenseContact

    func testWithValidLicenseContact() throws {
      let dictionary = JSONSerializationDictionary.creatorContact()
      let data = jsonData(licenseContact: .present(dictionary))
      XCTAssertNoThrow(try toObject(from: data))
    }

    func testWithInvalidLicenseContactTypeJSON() throws {
      let values: [Encodable] = [
        Int.random(in: Int.min...Int.max),
        Array<Int>.init(),
        (0..<10).map { $0 },
        Bool.random(),
      ]

      let data =
        values
        .map {
          jsonData(licenseContact: .present($0))
        }

      for data in data {
        typeMismatch(from: data) { typ, context in
          XCTAssert(typ is [String:Any].Type)
          XCTAssertFalse(context.codingPath.isEmpty)
          XCTAssertEqual(context.codingPath[0].stringValue, "licenseContact")
          XCTAssertNil(context.underlyingError)
        }
      }
    }

    func testMissingLicenseContact() throws {
      let data = jsonData(licenseContact: .absent)
      assertMissing(from: data, "licenseContact")
    }

    func testNullLicenseContact() throws {
      let data = jsonData(licenseContact: .present(nil))
      valueNotFound(from: data) { type, context in
        print(type, context)
        XCTAssert(type is [String:Any].Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "licenseContact")
        XCTAssertNil(context.underlyingError)
      }
    }

    // MARK: contextType

    func testWithValidContextType() throws {
      let contextType = UMLSContextType.random().rawValue
      let data = jsonData(contextType: .present(contextType))
      let result = try toObject(from: data).contextType
      XCTAssertEqual(result.rawValue, contextType)
    }

    func testWithInvalidContextType() throws {
      let string = String.randomAlphaNumericString(of: 10)
      let data = jsonData(contextType: .present(string))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "contextType")
        XCTAssertNil(context.underlyingError)
      }
    }

    func testWithInvalidContextTypeJSON() throws {
      let values: [Encodable] = [
        Int.random(in: Int.min...Int.max),
        Array<Int>.init(),
        (0..<10).map { $0 },
        Bool.random(),
      ]

      let data =
        values
        .map {
          jsonData(contextType: .present($0))
        }

      for data in data {
        typeMismatch(from: data) { typ, context in
          XCTAssert(typ is String.Type)
          XCTAssertFalse(context.codingPath.isEmpty)
          XCTAssertEqual(context.codingPath[0].stringValue, "contextType")
          XCTAssertNil(context.underlyingError)
        }
      }
    }

    func testMissingContextType() throws {
      let data = jsonData(contextType: .absent)
      assertMissing(from: data, "contextType")
    }

    func testNullContextType() throws {
      let data = jsonData(contextType: .present(nil))
      assertNull(from: data, "contextType")
    }

    func testWithContextTypePrefixSuffixWhitespaces() throws {
      let data = [" NONE", "NONE ", " NONE ", " FULL", "FULL ", "  FULL ", " FULL-MULTIPLE", "FULL-MULTIPLE ", " FULL-MULTIPLE "].map { jsonData(contextType: .present($0)) }

      for data in data {
        XCTAssertNoThrow(try toObject(from: data))
      }
    }

  }

#endif
