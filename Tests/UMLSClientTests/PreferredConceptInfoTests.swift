//  PreferredConceptInfoTests.swift

import Random
import UMLSClientModel
import XCTest

@testable import UMLSClient

final class PreferredConceptInfoTests: XCTestCase {

  var client: UMLSClient!

  override func setUpWithError() throws {
    self.client = .initializeTestClient()
  }

  override func tearDownWithError() throws {
    self.client = nil
  }

  func testWithValidRequest() async throws {
    let page = try await client.conceptController().preferred(.random())
    XCTAssertEqual(page.count, 1)
    XCTAssertEqual(page.number, 1)
    XCTAssertEqual(page.size, 25)

    let atomInfo = page.element
    XCTAssertTrue(!atomInfo.name.isEmpty)
  }

  func testWithInvalidAPIkey() async throws {
    client = .initializeTestClient(apiKey: .randomAlphaNumericString(of: 30))
    do {
      _ = try await client.conceptController().preferred(.random())
      XCTFail("Failed to raise `UMLSError`.")
    } catch let error as UMLSError {
      switch error {
      case .unauthorized:
        XCTAssert(true)
      default:
        XCTFail("Unexpected UMLS error: \(error)")
      }
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }

}
