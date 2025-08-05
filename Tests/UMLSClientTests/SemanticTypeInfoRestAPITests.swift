// SemanticTypeInfoRestAPITests.swift

import UMLSClientModel
import XCTest

@testable import UMLSClient

final class SemanticTypeInfoRestAPITests: XCTestCase {

  var client: UMLSClient!

  override func setUp() {
    self.client = .initializeTestClient()
  }

  func testWithValidRequest() async throws {
    let ui: UMLSUI<UMLSTUI> = .random()
    let pageInfo = try await client.semanticTypeController().info(of: ui)
    XCTAssertEqual(pageInfo.size, 25, "The page size(\(pageInfo.size)) is not equal to 25")
    XCTAssertEqual(pageInfo.count, 1, "The page count(\(pageInfo.count)) is not equal to 1")
    XCTAssertEqual(pageInfo.number, 1, "The page number (\(pageInfo.number)) is not equal to 1")
    XCTAssertEqual(
      pageInfo.element.ui, ui,
      """
      The requested semantic type identifier information is \(ui) which is not equal to reponse page result ui \(pageInfo.element.ui).
      """
    )
  }

  func object() -> UMLSUI<UMLSTUI> {
    let string = ProcessInfo.processInfo.environment["UMLS_ABSENT_STY_ID"]!
    return try! .init(string: string)
  }

  func testUINotPresent() async throws {
    do {
      _ = try await client.semanticTypeController().info(of: object())
    } catch let error as UMLSError {
      switch error {
      case .notFound:
        break
      default:
        XCTFail("Unexpected UMLS error: \(error)")
      }
    }
  }

  func testInvalidAuthorization() async throws {
    self.client = .initializeTestClient(apiKey: .randomAlphaNumericString(of: 20))
    do {
      _ = try await client.semanticTypeController().info(of: .random())
      XCTFail("Unable to raise a error")
    } catch let error as UMLSError {
      switch error {
      case .unauthorized:
        break
      default:
        XCTFail("Unexpected UMLS error: \(error)")
      }
    }
  }

}
