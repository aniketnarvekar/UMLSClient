//  UMLSUITests.swift

import UMLSClient
import XCTest

extension String {

  static func randomConceptString() -> String {
    "C\(Int.random(in: 1_000_000...9_999_999))"
  }

}

class UMLSUITestCase<T: UMLSUIType>: XCTestCase {

  var decoder: JSONDecoder!

  var encoder: JSONEncoder!

  override func setUp() {
    self.decoder = .init()
    self.encoder = .init()
  }

  func invalidFormat(string: String) {
    do {
      _ = try UMLSUI<T>(string: string)
      XCTFail("Unable to raise UMLSUIStringError error")
    } catch let error as UMLSUIStringError {
      switch error {
      case .invalidFormat:
        XCTAssert(true)
      default:
        XCTFail("Unexpected UMLSUIStringError: \(error)")
      }
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }

  func validFormat(string: String) throws {
    let ui = try UMLSUI<T>(string: string)
    XCTAssertEqual(ui.description, string)
  }

  func testValidDecode(strings: [String]) throws {
    let object = try decoder.decode([UMLSUI<T>].self, from: toJSON(strings: strings))
    XCTAssert(object.map({ $0.description }).elementsEqual(strings))
  }

  func toJSON(strings: [String]) throws -> Data {
    return try encoder.encode(strings)
  }

}

final class UMLSConceptUITests: UMLSUITestCase<UMLSConcept> {

  func testInitializeWithValidString() throws {
    let conceptString = String.randomConceptString()
    try validFormat(string: conceptString)
  }

  func testInitializeInvalidFormat() throws {
    let strings = [
      "C12345678",
      "C123456",
      "C123silc",
      "C192",
      "Z1234567",
      "12345C67",
      "1234567C",
      "1234_3689",
    ]

    for string in strings {
      invalidFormat(string: string)
    }
  }

}

#if SemanticType

  final class UMLSTUITests: UMLSUITestCase<UMLSTUI> {

    func testWithValidString() throws {
      for _ in 0..<100 {
        let string = "T\((100...999).randomElement()!)"
        try validFormat(string: string)
      }
    }

    func testWithInvalidString() throws {
      let strings: [String] = [
        "C123",
        "TABC",
        "t123",
        "TA12",
        "T1A3",
        "T12M",
        "T",
        "",
        "T1",
        "T12",
        "T1234",
      ]
      for string in strings {
        invalidFormat(string: string)
      }
    }

    func testDecodeValidIdentifier() throws {
      try testValidDecode(strings: ["T123"])
    }

    func testDecodeInvalidIdentifier() throws {
      let data = try toJSON(strings: [""])
      do {
        _ = try decoder.decode([UMLSUI<UMLSTUI>].self, from: data)
      } catch let error as DecodingError {
        switch error {
        case .dataCorrupted(_):
          assert(true)
        default:
          XCTFail("Unexpected Decoding Error: \(error)")
        }
      } catch {
        XCTFail("Unexpected Error: \(error)")
      }
    }

  }

#endif
