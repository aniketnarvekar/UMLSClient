//  UMLSAtomInfoDecodingTests.swift

import UMLSClient
import XCTest

final class UMLSAtomInfoDecodingTests: XCTestCase {

  var decoder: JSONDecoderAssertion<UMLSAtomInfo>!

  override func setUp() {
    self.decoder = .init()
  }

  func atomInfo(
    ui: String = "A\(Int.random(in: 1_000_000...99_999_999))",
    isSuppressible: String = .randomBoolString(),
    isObsolete: String = .randomBoolString(),
    sourceVocabulary: UMLSSourceVocabulary = .random(),
    termType: String = UMLSTermType.random().rawValue,
    language: String = UMLSLanguage.random().rawValue,
    name: String = String.randomAlphaNumericString(of: 100)
  ) -> Data {
    """
    {
        "ui": "\(ui)",
        "suppressible": "\(isSuppressible)",
        "obsolete": "\(isObsolete)",
        "rootSource": "\(sourceVocabulary.rawValue)",
        "termType": "\(termType)",
        "language": "\(language)",
        "name": "\(name)"
    }
    """.data(using: .utf8)!
  }

  func testWithValidJSON() throws {
    let ui = "A12827394"
    let isSuppressible = "true"
    let isObsolete = "true"
    let source = UMLSSourceVocabulary.random()
    let termType = UMLSTermType.random().rawValue
    let lang = UMLSLanguage.random().rawValue
    let name = String.randomAlphaNumericString(of: 10)
    let jsonData = atomInfo(
      ui: ui,
      isSuppressible: isSuppressible,
      isObsolete: isObsolete,
      sourceVocabulary: source,
      termType: termType,
      language: lang,
      name: name
    )
    let result = try decoder.decode(from: jsonData)
    XCTAssertEqual(result.ui.description, ui)
    XCTAssertTrue(result.isSuppressible)
    XCTAssertTrue(result.isObsolete)
    XCTAssertEqual(result.sourceVocabulary, source)
    XCTAssertEqual(result.termType.rawValue, termType)
    XCTAssertEqual(result.language.rawValue, lang)
    XCTAssertEqual(result.name, name)
  }

  func testUI() throws {
    let data = [
      atomInfo(ui: "A"),
      atomInfo(ui: "A1"),
      atomInfo(ui: "A123456"),
      atomInfo(ui: "A123456990"),
      atomInfo(ui: "R12345699"),
      atomInfo(ui: "C12345699"),
      atomInfo(ui: "A1234567_"),
      atomInfo(ui: "A1234567A"),
      atomInfo(ui: "A1234©670"),
    ]

    for data in data {
      decoder.assertCorrupted(from: data, for: "ui")
    }
  }

  func testInvalidIsSuppressible() throws {
    let data = [
      String.randomAlphaNumericString(of: 4),
      String.randomAlphaNumericString(of: 5),
    ].map({ atomInfo(isSuppressible: $0) })

    for data in data {
      decoder.assertCorrupted(
        from: data,
        for: "suppressible"
      )
    }
  }

  func testInvalidIsObsolete() throws {
    let data = [
      String.randomAlphaNumericString(of: 4),
      String.randomAlphaNumericString(of: 5),
    ].map({ atomInfo(isObsolete: $0) })

    for data in data {
      decoder.assertCorrupted(
        from: data,
        for: "obsolete"
      )
    }
  }

  func testEmptyName() throws {
    let jsonData = atomInfo(name: "")
    decoder.assertCorrupted(from: jsonData, for: "name")
  }

  func testInvalidTermType() throws {
    let data = [
      "",
      String.randomAlphaNumericString(of: 10),
    ].map({ atomInfo(termType: $0) })

    for data in data {
      decoder.assertCorrupted(from: data, for: "termType")
    }
  }

  func testInvalidLanguage() throws {
    let data = [
      "",
      String.randomAlphaNumericString(of: 10),
    ].map({ atomInfo(language: $0) })

    for data in data {
      decoder.assertCorrupted(from: data, for: "language")
    }
  }

}
