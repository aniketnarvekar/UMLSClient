//  UMLSPageDecodingTests.swift

import UMLSClient
import XCTest

final class UMLSPageDecodingTests: XCTestCase {

  func semanticTypeJSON(name: UMLSSemanticType = .random()) -> Data {
    """
    {
    "name": "\(name.rawValue)",
    }
    """.data(using: .utf8)!
  }

  func conceptPageJSON(
    pageSize: Int = 25,
    pageNumber: Int = 1,
    pageCount: Int = 1,
    ui: String = "C\(Int.random(in: 1_000_000...9_999_999))",
    name: String = String.randomAlphaNumericString(of: 10),
    dateAdded: String = Date.randomDateString(),
    majorRevisionDate: String = Date.randomDateString(),
    isSuppressible: Bool = .random(),
    status: String = ["R", "U"].randomElement()!,
    semanticTypes: [UMLSSemanticType] = [
      .random()
    ],
    atomCount: Int = .random(in: 0...Int.max),
    cvMemberCount: Int = .random(in: 0...Int.max),
    attributeCount: Int = .random(in: 0...Int.max),
    relationCount: Int = .random(in: 0...Int.max)
  ) -> Data {
    """
    {
        "pageSize": \(pageSize),
        "pageNumber": \(pageNumber),
        "pageCount": \(pageCount),
        "result": {
        "ui": "\(ui)",
        "name": "\(name)",
        "dateAdded": "\(dateAdded)",
        "majorRevisionDate": "\(majorRevisionDate)",
        "suppressible": \(isSuppressible),
        "status": "\(status)",
        "semanticTypes": [\(semanticTypes.map({ semanticTypeJSON(name: $0) }).map({ String(data: $0, encoding: .utf8)! }).joined(separator: ","))],
        "atomCount": \(atomCount),
        "cvMemberCount": \(cvMemberCount),
        "attributeCount": \(attributeCount),
        "relationCount": \(relationCount)
        }
    }
    """.data(using: .utf8)!
  }

  override func setUp() {

  }

  func testWithValidJSON() throws {
    let pageSize = 25
    let pageNumber = 1
    let pageCount = 1
    let jsonData = conceptPageJSON(
      pageSize: pageSize,
      pageNumber: pageNumber,
      pageCount: pageCount
    )
    let jsonDecoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy"
    jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    let decoder = JSONDecoderAssertion<UMLSPage<UMLSConceptInfo>>(decoder: jsonDecoder)
    let object = try! decoder.decode(from: jsonData)
    XCTAssertEqual(object.count, pageCount)
    XCTAssertEqual(object.size, pageSize)
    XCTAssertEqual(object.number, pageNumber)
  }

  func nullPageSize(size: Int = 25, number: Int = 1, count: Int = 1) -> Data {
    """
    {
    "pageSize": \(size),
    "pageNumber": \(number),
    "pageCount": \(count),
    "result": null
    }
    """.data(using: .utf8)!
  }

  func testWithNullElement() throws {
    let jsonData = nullPageSize()
    let decoder = JSONDecoderAssertion<UMLSPage<UMLSConceptInfo?>>()
    let result = try decoder.decode(from: jsonData)
    XCTAssertNil(result.element)
  }

  func testWithEmptyListElement() throws {
    let jsonData = """
      {
      "pageSize": 25,
      "pageNumber": 1,
      "pageCount": 1,
      "result": []
      }
      """.data(using: .utf8)!
    let decoder = JSONDecoderAssertion<UMLSPage<[UMLSConceptInfo]>>()
    let result = try decoder.decode(from: jsonData)
    XCTAssertTrue(result.element.isEmpty)
  }

  func testWithNonEmptyListElement() throws {
    let jsonData = """
      {
      "pageSize": 25,
      "pageNumber": 1,
      "pageCount": 1,
      "result": [{
              "classType": "Concept",
              "ui": "C0009044",
              "suppressible": false,
              "dateAdded": "09-30-1990",
              "majorRevisionDate": "08-18-2015",
              "status": "R",
              "semanticTypes": [
                  {
                      "name": "Injury or Poisoning",
                      "uri": "https://uts-ws.nlm.nih.gov/rest/semantic-network/2015AB/TUI/T037"
                  }
              ],
              "atomCount": 63,
              "attributeCount": 0,
              "cvMemberCount": 0,
              "atoms": "https://uts-ws.nlm.nih.gov/rest/content/2015AB/CUI/C0009044/atoms",
              "definitions": "NONE",
              "relations": "https://uts-ws.nlm.nih.gov/rest/content/2015AB/CUI/C0009044/relations",
              "defaultPreferredAtom": "https://uts-ws.nlm.nih.gov/rest/content/2015AB/CUI/C0009044/atoms/preferred",
              "relationCount": 5,
              "name": "Closed fracture carpal bone"
          }]
      }
      """.data(using: .utf8)!
    let jsonDecoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy"
    jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    let decoder = JSONDecoderAssertion<UMLSPage<[UMLSConceptInfo]>>(decoder: jsonDecoder)
    let result = try decoder.decode(from: jsonData)
    XCTAssertFalse(result.element.isEmpty)
    XCTAssertEqual(result.element.count, 1)
  }

}
