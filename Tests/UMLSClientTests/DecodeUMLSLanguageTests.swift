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
