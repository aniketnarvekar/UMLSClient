//  UMLConceptInfoDecodableTests.swift

import UMLSClient
import XCTest

final class UMLSConceptInfoDecodableTests: XCTestCase {

  var decoder: JSONDecoderAssertion<UMLSConceptInfo>!

  override func setUp() {
    let decoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    self.decoder = .init(decoder: decoder)
  }

  func semanticTypeJSON(name: UMLSSemanticType = .random()) -> Data {
    """
    {
      "name": "\(name.rawValue)",
    }
    """.data(using: .utf8)!
  }

  func conceptJSON(
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
    """.data(using: .utf8)!
  }

  func testValidDecoding() throws {
    let name = String.randomAlphaNumericString(of: 50)
    let dateAdded = "04-16-1993"
    let majorRevisionDate = "08-10-2022"
    let isSuppressible = [true, false].randomElement()!
    let atomCount = Int.random(in: 0...Int.max)
    let cvMemberCount = Int.random(in: 0...Int.max)
    let attributeCount = Int.random(in: 0...Int.max)
    let relationCount = Int.random(in: 0...Int.max)
    let jsonData = conceptJSON(
      name: name,
      dateAdded: dateAdded,
      majorRevisionDate: majorRevisionDate,
      isSuppressible: isSuppressible,
      status: "R",
      atomCount: atomCount,
      cvMemberCount: cvMemberCount,
      attributeCount: attributeCount,
      relationCount: relationCount
    )
    let object = try decoder.decode(from: jsonData)
    XCTAssertEqual(object.name, name)
    XCTAssertEqual(
      object.dateAdded, DateComponents(calendar: .current, year: 1993, month: 04, day: 16).date!)
    XCTAssertEqual(
      object.majorRevisionDate,
      DateComponents(calendar: .current, year: 2022, month: 08, day: 10).date!)
    XCTAssertEqual(object.isSuppressible, isSuppressible)
    XCTAssertEqual(object.status, .reviewed)
    XCTAssertEqual(object.atomCount, atomCount)
    XCTAssertEqual(object.cvMemberCount, cvMemberCount)
    XCTAssertEqual(object.attributeCount, attributeCount)
    XCTAssertEqual(object.relationCount, relationCount)
    XCTAssertEqual(object.semanticTypes.count, 1)
  }

  func testEmptyName() throws {
    let jsonData = conceptJSON(name: "")
    decoder.assertCorrupted(from: jsonData, for: "name")
  }

  func testNegativeAtomCount() throws {
    let jsonData = conceptJSON(atomCount: Int.random(in: Int.min..<0))
    decoder.assertCorrupted(from: jsonData, for: "atomCount")
  }

  func testNegativecvMemberCount() throws {
    let jsonData = conceptJSON(cvMemberCount: Int.random(in: Int.min..<0))
    decoder.assertCorrupted(from: jsonData, for: "cvMemberCount")
  }

  func testNegativeAttributeCount() throws {
    let jsonData = conceptJSON(attributeCount: .random(in: Int.min..<0))
    decoder.assertCorrupted(from: jsonData, for: "attributeCount")
  }

  func testNagativeRelationcount() throws {
    let jsonData = conceptJSON(relationCount: .random(in: Int.min..<0))
    decoder.assertCorrupted(from: jsonData, for: "relationCount")
  }

  func testNoSemantictypes() throws {
    let jsonData = """
      {
          "ui": "C0155502",
          "name": "Benign Paroxysmal Positional Vertigo",
          "dateAdded": "04-16-1993",
          "majorRevisionDate": "08-10-2022",
          "classType": "Concept",
          "suppressible": false,
          "status": "R",
          "semanticTypes": [],
          "atoms": "https://uts-ws.nlm.nih.gov/rest/content/2024AB/CUI/C0155502/atoms",
          "definitions": "https://uts-ws.nlm.nih.gov/rest/content/2024AB/CUI/C0155502/definitions",
          "relations": "https://uts-ws.nlm.nih.gov/rest/content/2024AB/CUI/C0155502/relations",
          "defaultPreferredAtom": "https://uts-ws.nlm.nih.gov/rest/content/2024AB/CUI/C0155502/atoms/preferred",
          "atomCount": 198,
          "cvMemberCount": 0,
          "attributeCount": 0,
          "relationCount": 8
          }
      """.data(using: .utf8)!
    decoder.assertCorrupted(
      from: jsonData,
      for: "semanticTypes",
      debugDescription: "At least 1 semantic type should be present for a concept."
    )
  }

  func testInvalidDateAddedFormat() throws {
    let data = [
      conceptJSON(dateAdded: "\(Int.random(in: 13...31))-1-1993"),
      conceptJSON(dateAdded: "04-\(Int.random(in: 32...Int.max))-1993"),
    ]

    for data in data {
      decoder.assertCorrupted(
        from: data,
        for: "dateAdded",
        debugDescription: "Date string does not match format expected by formatter."
      )
    }
  }

  func testInvalidMajorRevisionDateFormat() throws {
    let data = [
      conceptJSON(majorRevisionDate: "\(Int.random(in: 13...31))-10-2022"),
      conceptJSON(majorRevisionDate: "8-\(Int.random(in: 31...Int.max))-2022"),
    ]

    for data in data {
      decoder.assertCorrupted(
        from: data,
        for: "majorRevisionDate",
        debugDescription: "Date string does not match format expected by formatter."
      )
    }
  }

}
