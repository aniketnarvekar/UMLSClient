// UMLSSearchControllerTests.swift
// Test search controller components.

import UMLSClientModel
import XCTest

@testable import UMLSClient

final class UMLSSearchControllerTests: XCTestCase {

  var searchController: UMLSSearchController!

  override func setUp() async throws {
    let apiKey = ProcessInfo.processInfo.environment["UMLS_API_KEY"]!
    let hostString = ProcessInfo.processInfo.environment["UMLS_HOST"]!
    let host = URL(string: hostString)!
    let versionString = ProcessInfo.processInfo.environment["UMLS_VERSION"]!
    let version = try! UMLSVersion(string: versionString)
    searchController = UMLSClient(baseURL: host, apiKey: apiKey, version: version)
      .searchController()
  }

  override func tearDown() async throws {
    self.searchController = nil
  }

  func testCompleteWordSearch() async throws {
    let result = try await searchController.search(
      UMLSSearchParametersBuilder(String.randomAlphaNumericString(of: 10)).build())
    XCTAssertGreaterThan(result.number, 0)
    XCTAssertGreaterThan(result.size, 0)
    XCTAssertGreaterThan(result.count, 0)
    XCTAssertGreaterThan(result.elements.count, 0)
  }

  func testPartialWordSearch() async throws {
    let builder = try UMLSSearchParametersBuilder(String.randomAlphaNumericString(of: 10))
      .setPartialSearch(true)
    let result = try await searchController.search(builder.build())
    XCTAssertGreaterThan(result.number, 0)
    XCTAssertGreaterThan(result.size, 0)
    XCTAssertGreaterThan(result.count, 0)
    XCTAssertGreaterThan(result.elements.count, 0)
  }

  func testCompleteExactSearch() async throws {
    let builder = try UMLSSearchParametersBuilder(String.randomAlphaNumericString(of: 10))
      .setSearchType(.exact)
    let result = try await searchController.search(builder.build())
    XCTAssertGreaterThan(result.number, 0)
    XCTAssertGreaterThan(result.size, 0)
    XCTAssertGreaterThan(result.count, 0)
    XCTAssertGreaterThan(result.elements.count, 0)
  }

  func testParticalExactSearch() async throws {
    let builder = try UMLSSearchParametersBuilder(String.randomAlphaNumericString(of: 10))
      .setSearchType(.exact)
      .setPartialSearch(true)
    let result = try await searchController.search(builder.build())
    XCTAssertGreaterThan(result.number, 0)
    XCTAssertGreaterThan(result.size, 0)
    XCTAssertGreaterThan(result.count, 0)
    XCTAssertGreaterThan(result.elements.count, 0)
  }

}
