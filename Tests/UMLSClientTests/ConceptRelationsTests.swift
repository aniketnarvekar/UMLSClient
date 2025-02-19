//  ConceptRelationsTests.swift

import Foundation
import XCTest

@testable import UMLSClient

class ConceptRelationsTests: XCTestCase, UMLSRelationTestUtility {

  var client: UMLSClient!

  override func setUp() {
    self.client = .initializeTestClient()
  }

  override func tearDown() {
    self.client = nil
  }

  func testWithDefaultParameters() async throws {
    let result = try await relations(using: .init(concept: .random()))
    XCTAssertEqual(result.size, 25)
    XCTAssertEqual(result.number, 1)
    XCTAssertEqual(result.count, result.getTestPageCount())

    let element = result.element
    XCTAssertTrue(element.every(completion: { !$0.isObsolete }))
    XCTAssertTrue(element.every(completion: { !$0.isSuppressible }))
    XCTAssertTrue(element.some(completion: { $0.isSourceOriented }))
    XCTAssertTrue(element.some(completion: { !$0.isSourceOriented }))
    XCTAssertTrue(element.every(completion: { !$0.relatedIdName.isEmpty }))
    XCTAssertTrue(element.every(completion: { !$0.relatedFromIdName.isEmpty }))

  }

  func testInvalidAPIKey() async throws {
    try await unautorizedError { client in
      return try await relations(using: .init(concept: .random()))
    }
  }

  func testZeroPageSize() async throws {
    let result = try await relations(
      using: .init(concept: .random()).setPageInfo(.init(size: 0))
    )
    XCTAssertEqual(result.size, 25)
    XCTAssertLessThanOrEqual(result.element.count, 25)
  }

  func testZeroPageNumber() async throws {
    let result = try await relations(
      using: .init(concept: .random()).setPageInfo(.init(number: 0))
    )
    XCTAssertEqual(result.number, 1)
  }

  func testPageSizeGreaterThan10000() async throws {
    try await clientError { client in
      return try await relations(
        using: .init(concept: .random()).setPageInfo(
          .init(size: .init((1001...Int.max).randomElement()!))
        )
      )
    }
  }

  func testPageSizeGreaterThan5000AndPageNumberGreaterThan1() async throws {
    try await clientError { client in
      return try await relations(
        using: .init(concept: .random()).setPageInfo(
          .init(
            size: .init((5001...Int.max).randomElement()!),
            number: .init((2...Int.max).randomElement()!)
          )
        )
      )
    }
  }

  func testSingleRelationLabel() async throws {
    let label = UMLSRelationLabel.random()
    let result = try await relations(using: .init(concept: .random()).addRelationLabel(label))
    XCTAssertTrue(result.element.every(completion: { $0.relationLabel == label }))
  }

  func testSingleSourcevocabulary() async throws {
    let sourceVocabulary = UMLSSourceVocabulary.random()
    let result = try await relations(
      using: .init(concept: .random()).addSourceVocabulary(sourceVocabulary)
    )
    XCTAssertTrue(result.element.every(completion: { $0.sourceVocabulary == sourceVocabulary }))
  }

  func testSingleAdditionalRelationLabel() async throws {
    let additionalRelationLabel = UMLSAdditionalRelationLabel.random()
    let result = try await relations(
      using: .init(concept: .random()).addAdditionalRelationLabel(additionalRelationLabel)
    )
    XCTAssertTrue(
      result.element
        .every(completion: { $0.additionalRelationLabel == additionalRelationLabel })
    )
  }

  func testMultipleRelationLabels() async throws {
    let labels: [UMLSRelationLabel] = [.aq, .chd, .del, .none, .par, .qb, .rb, .rn]
    let result = try await relations(using: .init(concept: .random()).setRelationLabels(labels))
    XCTAssertTrue(result.element.every(completion: { labels.contains($0.relationLabel) }))
  }

  func testMultipleSourceVocabularies() async throws {
    let labels: [UMLSSourceVocabulary] = [.air, .alt, .aod, .aot, .atc, .bi, .ccc]
    let result = try await relations(using: .init(concept: .random()).setSourceVocabulary(labels))
    XCTAssertTrue(result.element.every(completion: { labels.contains($0.sourceVocabulary) }))
  }

  func testMultipleAdditionalRelationLabel() async throws {
    let labels: [UMLSAdditionalRelationLabel] = [
      .abnormalCellAffectedByChemicalOrDrug,
      .absorbabilityOf,
      .accessOf,
      .activityOfAllele,
      .afferentTo,
      .after,
    ]
    let result = try await relations(
      using: .init(concept: .random()).setAdditionalRelationLabels(labels)
    )
    XCTAssertTrue(
      result.element.every(completion: { labels.contains($0.additionalRelationLabel) })
    )
  }

  func testIncludeObsolete() async throws {
    let result = try await relations(using: .init(concept: .random()).setIncludeObsolete(true))
    XCTAssertTrue(result.element.some(completion: { $0.isObsolete }))
    XCTAssertTrue(result.element.some(completion: { !$0.isObsolete }))
  }

  func testIncludeSuppressible() async throws {
    let result = try await relations(
      using: .init(concept: .random()).setIncludeSuppressible(true)
    )
    XCTAssertTrue(result.element.some(completion: { $0.isSuppressible }))
    XCTAssertTrue(result.element.some(completion: { !$0.isSuppressible }))
  }

}

protocol UMLSRelationTestUtility: UMLSTestUtility {}

extension UMLSRelationTestUtility {

  func relations(
    using builder: UMLSConceptRelationParametersBuilder
  ) async throws -> UMLSPage<[UMLSRelationship]> {
    try await self.client.conceptController().relations(using: builder.build())
  }

}
