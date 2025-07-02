// FetchAllSourceVocabularyTests.swift

import UMLSClient
import XCTest

final class FetchAllSourceVocabularyTests: XCTestCase, UMLSTestUtility {

  var client: UMLSClient!

  override func setUp() {
    super.setUp()
    self.client = .initializeTestClient()
  }

  override func tearDown() {
    super.tearDown()
    self.client = nil
  }

  func testValidAPIKey() async throws {
    let object = try await client.sourceVocabularyController().fetchAll()
    XCTAssertTrue(object.isPageHasAllData)
    XCTAssertEqual(.init(UMLSClient.getTestContentSize()), object.element.count)
  }

  func testInvalidAPIKey() async throws {
    try await unautorizedError { client in
      try await client.sourceVocabularyController().fetchAll()
    }
  }

}
