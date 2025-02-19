//  ConceptInfoTests.swift

import UMLSClient
import XCTest

final class ConceptInfoTests: XCTestCase {

  var client: UMLSClient!

  override func setUp() {
    self.client = .initializeTestClient()
  }

  func testConceptInfoWithValidRequest() async throws {
    let page = try await client.conceptController().info(of: .random())
    XCTAssertEqual(page.count, 1)
    XCTAssertEqual(page.number, 1)
    XCTAssertEqual(page.size, 25)

    let conceptInfo = page.element
    XCTAssertGreaterThanOrEqual(conceptInfo.atomCount, 0)
    XCTAssertGreaterThanOrEqual(conceptInfo.attributeCount, 0)
    XCTAssertGreaterThanOrEqual(conceptInfo.cvMemberCount, 0)
    XCTAssertGreaterThanOrEqual(conceptInfo.relationCount, 0)
    XCTAssertLessThan(conceptInfo.dateAdded, conceptInfo.majorRevisionDate)
    XCTAssertFalse(conceptInfo.semanticTypes.isEmpty)
    XCTAssertTrue(!conceptInfo.semanticTypes.map({ !$0.name.isEmpty }).contains(false))
    XCTAssertFalse(conceptInfo.name.isEmpty)
  }

  func testConceptInfoWithInvalidApiKey() async throws {
    self.client = .initializeTestClient(apiKey: .randomAlphaNumericString(of: 30))
    do {
      _ = try await client.conceptController().info(of: .random())
      XCTFail("Unable to raise UMLSError.")
    } catch let error as UMLSError {
      switch error {
      case .unauthorized:
        XCTAssert(true)
      default:
        XCTFail("Unexpected UMLSError: \(error)")
      }
    }
  }

  func testWithInvalidDateDecodingStrategy() async throws {
    self.client = .initializeTestClient(decoder: .init())

    do {
      _ = try await client.conceptController().info(of: .random())
    } catch let error as UMLSError {
      switch error {
      case .decodingError(error: let error as DecodingError):
        switch error {
        case DecodingError.typeMismatch(_, let context):
          XCTAssertEqual(context.codingPath[0].stringValue, "result")
          XCTAssertEqual(context.codingPath[1].stringValue, "dateAdded")
        default:
          XCTFail()
        }
      default:
        XCTFail()
      }
    }
  }

}
