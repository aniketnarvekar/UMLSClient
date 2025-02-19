//  ConceptDefinitionsTests.swift

import XCTest

@testable import UMLSClient

extension UMLSPage {

  func getTestPageCount() -> Int {
    let contentCount = Int(UMLSClient.getTestContentSize())
    var result = contentCount / size
    result += contentCount % size > 0 ? 1 : 0
    return result
  }

}

final class ConceptDefinitionsTests: XCTestCase, UMLSTestUtility {

  var client: UMLSClient!

  override func setUpWithError() throws {
    self.client = .initializeTestClient()
  }

  override func tearDownWithError() throws {
    self.client = nil
  }

  func testWithDefaultRequest() async throws {
    let params = UMLSConceptDefinitionParametersBuilder(concept: .random())
      .build()
    let page = try await client.conceptController().definitions(using: params)
    XCTAssertEqual(page.size, 25)
    XCTAssertEqual(page.number, 1)
    XCTAssertEqual(page.count, page.getTestPageCount())
    XCTAssertTrue(!page.element.isEmpty)
    XCTAssertLessThanOrEqual(page.element.count, page.size)

    let element = page.element
    XCTAssertTrue(!element.map({ !$0.definition.isEmpty }).contains(false))

  }

  func testWithInvalidAPIKey() async throws {
    self.client = .initializeTestClient(apiKey: .randomAlphaNumericString(of: 30))

    try await self.unautorizedError { client in
      let params = UMLSConceptDefinitionParametersBuilder(concept: .random()).build()
      return try await client.conceptController().definitions(using: params)
    }

  }

  func testWithZeroPageNumber() async throws {
    let params = UMLSConceptDefinitionParametersBuilder(concept: .random())
      .setPageInfo(.init(number: 0))
      .build()
    let page = try await client.conceptController().definitions(using: params)
    XCTAssertEqual(page.number, 1)
    XCTAssertEqual(page.size, 25)
    XCTAssertEqual(page.count, page.getTestPageCount())
    XCTAssertLessThanOrEqual(page.element.count, page.size)
  }

  func conceptDefinitionParameter(
    pageSize: UInt = PageInfo.DEFAULT_SIZE,
    pageNumber: UInt = PageInfo.DEFAULT_NUMBER,
    sourceVocabularies: [UMLSSourceVocabulary] = []
  ) -> UMLSConceptDefinitionParameters {
    UMLSConceptDefinitionParametersBuilder(concept: .random())
      .setPageInfo(.init(size: pageSize, number: pageNumber))
      .setSourceVocabulary(sourceVocabularies)
      .build()
  }

  func testWithZeroPageSize() async throws {
    let page = try await client.conceptController().definitions(
      using: conceptDefinitionParameter(pageSize: 0)
    )
    XCTAssertEqual(page.number, 1)
    XCTAssertEqual(page.size, 25)
    XCTAssertEqual(page.count, page.getTestPageCount())
    XCTAssertLessThanOrEqual(page.element.count, page.size)
  }

  func testWithPageSizeGreaterThan10000() async throws {
    try await clientError { client in
      let size = UInt((10001...Int.max).randomElement()!)
      _ =
        try await client
        .conceptController()
        .definitions(using: conceptDefinitionParameter(pageSize: size))
    }
  }

  func testPageSizeGreaterThan5000AndNumberGreaterThan1() async throws {
    try await clientError { client in
      let size = UInt((5001...Int.max).randomElement()!)
      let number = UInt((2...Int.max).randomElement()!)
      _ =
        try await client
        .conceptController()
        .definitions(using: conceptDefinitionParameter(pageSize: size, pageNumber: number))
    }
  }

  func testPageNumberGreaterThanPageCount() async throws {
    let pageSize = UInt(25)
    let totalSize = UMLSClient.getTestContentSize()

    var pageCount = totalSize / pageSize
    pageCount += totalSize % pageSize > 0 ? 1 : 0

    let pageNumber = pageCount + 1

    let params = conceptDefinitionParameter(pageSize: pageSize, pageNumber: pageNumber)
    let result = try await client.conceptController().definitions(using: params)

    XCTAssertEqual(UInt(result.size), pageSize)
    XCTAssertEqual(UInt(result.count), pageCount)
    XCTAssertEqual(UInt(result.number), pageNumber)
    XCTAssertTrue(result.element.isEmpty)

  }

}

protocol UMLSTestUtility: NSObjectProtocol {

  var client: UMLSClient! { get set }

}

extension UMLSTestUtility {

  func _catcher<T>(
    _ completionHandler: (UMLSClient) async throws -> T,
    errorHandler: (UMLSError) -> Void
  ) async throws {
    do {
      _ = try await completionHandler(client)
      XCTFail("Unable to raise UMLSError.")
    } catch let error as UMLSError {
      errorHandler(error)
    } catch {
      XCTFail("Unable to raise UMLSError.")
    }
  }

  func unautorizedError<T>(
    _ completionHandler: (UMLSClient) async throws -> T
  ) async throws {
    self.client = UMLSClient.initializeTestClient(apiKey: .randomAlphaNumericString(of: 30))
    try await _catcher(completionHandler) { error in
      switch error {
      case .unauthorized:
        XCTAssert(true)
      default:
        XCTFail("Unexpected UMLSError: \(error)")
      }
    }
  }

  func clientError<T>(
    _ completionHandler: (UMLSClient) async throws -> T,
    _ messageHandler: ((String) -> Void)? = nil
  ) async throws {
    try await _catcher(completionHandler) { error in
      switch error {
      case .client(let message):
        messageHandler?(message)
        XCTAssert(true)
      default:
        XCTFail("Unexpected UMLS error: \(error)")
      }
    }
  }

}
