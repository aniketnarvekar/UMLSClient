//  UMLSConceptDefinitionParametersBuilderTests.swift

import UMLSClient
import XCTest

final class UMLSConceptDefinitionParametersBuilderTests: XCTestCase {

  var builder: UMLSConceptDefinitionParametersBuilder!

  override func setUp() {
    self.builder = .init(concept: .random())
  }

  func testDefault() throws {
    let concept: UMLSUI<UMLSConcept> = .random()
    builder = UMLSConceptDefinitionParametersBuilder(concept: concept)
    let result = builder.build()
    XCTAssertEqual(result.concept, concept)
    XCTAssertTrue(result.sourceVocabularies.isEmpty)
    XCTAssertEqual(result.page, .init())
  }

  func testAddSingleSource() throws {
    let sourceVocabulary = UMLSSourceVocabulary.random()
    let result =
      builder
      .addSourceVocabulary(sourceVocabulary)
      .build()
    XCTAssertFalse(result.sourceVocabularies.isEmpty)
    XCTAssertEqual(result.sourceVocabularies.count, 1)
    XCTAssertEqual(result.sourceVocabularies[0], sourceVocabulary)
  }

  func testAddDuplicateSources() throws {
    let string = UMLSSourceVocabulary.random()
    let sourceVocabularies = (0...10).map({ _ in string })
    sourceVocabularies.forEach({ _ = builder.addSourceVocabulary($0) })
    let result = builder.build()
    XCTAssertEqual(result.sourceVocabularies.count, 1)
    XCTAssertEqual(result.sourceVocabularies[0], string)
  }

  // To get the sequence of added source vocabulary. Considering added source vocabulary name is unique the first inserted comes the first in build object source and last added comes the last in the source vocabulary.
  func testAddMultipleSources() throws {
    let sourceVocabularies = Array(UMLSSourceVocabulary.allCases[..<10])
    sourceVocabularies.forEach({ _ = builder.addSourceVocabulary($0) })
    let result = builder.build()
    XCTAssertEqual(result.sourceVocabularies.count, 10)
    XCTAssertEqual(result.sourceVocabularies, sourceVocabularies)
  }

  func testSetDuplicatesSources() throws {
    let string = UMLSSourceVocabulary.random()
    let sourceVocabularies = (0...10).map({ _ in string })
    let result =
      builder
      .setSourceVocabulary(sourceVocabularies)
      .build()
    XCTAssertEqual(result.sourceVocabularies.count, 1)
    XCTAssertEqual(result.sourceVocabularies[0], string)
  }

  func testRemoveSingle() throws {
    let sabs: [UMLSSourceVocabulary] = [
      .air,
      .alt,
      .aot,
      .aod,
      .bi,
      .ccpss,
      .ccsrIcd10pcs,
      .cpt,
      .go,
      .icd10am,
    ]
    var result = builder.setSourceVocabulary(sabs).build()
    XCTAssertEqual(result.sourceVocabularies.count, 10)
    XCTAssertEqual(result.sourceVocabularies.first!, sabs.first!)
    // Remove first element source vocabulary from the builder
    result = builder.removeSourceVocabulary(sabs.first!).build()
    XCTAssertEqual(result.sourceVocabularies.count, 9)
    XCTAssertNotEqual(result.sourceVocabularies.first!, sabs.first!)
    XCTAssertEqual(result.sourceVocabularies.first!, sabs[1])
    // try to remove first element of source vocabulary from the builder
    result = builder.removeSourceVocabulary(sabs.first!).build()
    XCTAssertEqual(result.sourceVocabularies.count, 9)
    XCTAssertNotEqual(result.sourceVocabularies.first!, sabs.first!)
    // try to remove last element of the source vocabulary from the builder
    result = builder.removeSourceVocabulary(sabs.last!).build()
    XCTAssertEqual(result.sourceVocabularies.count, 8)
    XCTAssertNotEqual(result.sourceVocabularies.last!, sabs.last!)
    XCTAssertEqual(result.sourceVocabularies.last!, sabs[8])
  }

  func testPageInfo() throws {
    var result = builder.setPageInfo(.init(size: 100)).build()
    XCTAssertEqual(result.page.size, 100)
    XCTAssertEqual(result.page.number, 1)
    result = builder.setPageInfo(.init(number: 10)).build()
    XCTAssertEqual(result.page.size, 25)
    XCTAssertEqual(result.page.number, 10)
  }

}
