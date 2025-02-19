//  UMLSConceptAtomParametersBuilderTests.swift

import UMLSClient
import XCTest

final class UMLSConceptAtomParametersBuilderTests: XCTestCase {

  var builder: UMLSConceptAtomParametersBuilder!

  override func setUp() {
    self.builder = .init(concept: .random())
  }

  func testDefault() throws {
    let concept: UMLSUI<UMLSConcept> = .random()
    self.builder = .init(concept: concept)
    let result = self.builder.build()
    XCTAssertEqual(result.concept, concept)
    XCTAssertEqual(result.page, .init())
    XCTAssertTrue(result.sourceVocabularies.isEmpty)
    XCTAssertTrue(result.termTypes.isEmpty)
    XCTAssertFalse(result.includeObsolete)
    XCTAssertFalse(result.includeSuppressible)
    XCTAssertNil(result.language)
  }

  func testPageInfo() throws {
    var result = self.builder.setPageInfo(.init(size: 100)).build()
    XCTAssertEqual(result.page.size, 100)
    XCTAssertEqual(result.page.number, 1)
    result = self.builder.setPageInfo(.init(number: 10)).build()
    XCTAssertEqual(result.page.size, 25)
    XCTAssertEqual(result.page.number, 10)
    result = self.builder.setPageInfo(.init(size: 100, number: 10)).build()
    XCTAssertEqual(result.page.size, 100)
    XCTAssertEqual(result.page.number, 10)
  }

  func testIncludeObsolete() throws {
    var result = builder.setIncludeObsolete(true).build()
    XCTAssertTrue(result.includeObsolete)
    result = builder.setIncludeObsolete(false).build()
    XCTAssertFalse(result.includeSuppressible)
  }

  func testIncludeSuppressible() throws {
    var result = builder.setIncludeSuppressible(true).build()
    XCTAssertTrue(result.includeSuppressible)
    result = builder.setIncludeSuppressible(false).build()
    XCTAssertFalse(result.includeSuppressible)
  }

  func testSetLanguage() throws {
    var result = builder.setLanguage(.random()).build()
    XCTAssertNotNil(result.language)
    result = builder.setLanguage(nil).build()
    XCTAssertNil(result.language)
    result = builder.setLanguage(.random()).build()
    XCTAssertNotNil(result.language)
  }

  // Check if to be able to add UMLS term type if it does not exist. The added term type is added at the last of the term types list.
  func testAddUniqueTermType() throws {
    var result = builder.addTermType(.aa).build()
    XCTAssertEqual(result.termTypes.count, 1)
    XCTAssertEqual(result.termTypes[0], .aa)
    result = builder.addTermType(.ab).build()
    XCTAssertEqual(result.termTypes.count, 2)
    XCTAssertEqual(result.termTypes[0], .aa)
    XCTAssertEqual(result.termTypes[1], .ab)
    result = builder.addTermType(.di).build()
    XCTAssertEqual(result.termTypes.count, 3)
    XCTAssertEqual(result.termTypes[0], .aa)
    XCTAssertEqual(result.termTypes[1], .ab)
    XCTAssertEqual(result.termTypes[2], .di)
  }

  func testAddDuplicateTermType() throws {
    let tty = UMLSTermType.random()
    let result = builder.addTermType(tty).build()
    XCTAssertEqual(result.termTypes.count, 1)
    _ =
      builder
      .addTermType(tty)
      .addTermType(tty)

    XCTAssertEqual(result.termTypes.count, 1)
    XCTAssertEqual(result.termTypes[0], tty)

  }

  func testRemoveExistingTermType() throws {

    _ =
      builder
      .addTermType(.aa)
      .addTermType(.ab)
      .addTermType(.ac)
      .addTermType(.ad)

    var result = builder.removeTermType(.ab).build()
    XCTAssertEqual(result.termTypes.count, 3)
    XCTAssertEqual(result.termTypes[0], .aa)
    XCTAssertEqual(result.termTypes[1], .ac)
    XCTAssertEqual(result.termTypes[2], .ad)

    result = builder.removeTermType(.aa).build()
    XCTAssertEqual(result.termTypes[0], .ac)

    result = builder.removeTermType(.ad).build()
    XCTAssertEqual(result.termTypes[0], .ac)
  }

  func testRemoveTermTypeFromEmptyList() throws {
    let result = builder.removeTermType(.aa).build()
    XCTAssertEqual(result.termTypes.count, 0)
  }

  // Test if build object contains all the unique elements in same order which is being set.
  func testSetUniqueTermTypes() throws {
    let termTypes: [UMLSTermType] = [.aa, .ab, .ac, .ad, .di, .si, .sy]
    let result = builder.setTermTypes(termTypes).build()
    XCTAssertEqual(result.termTypes.count, 7)
    XCTAssertEqual(result.termTypes, [.aa, .ab, .ac, .ad, .di, .si, .sy])
  }

  // Test if the list contains a duplicate element; if present, keep the first element and remove other duplicate elements from their position and rearrange other elements.
  func testSetDuplicateTermTypes() throws {
    var termTypes: [UMLSTermType] = [.aa, .aa, .aa, .aa, .aa]
    var result = builder.setTermTypes(termTypes).build()
    XCTAssertEqual(result.termTypes.count, 1)
    XCTAssertEqual(result.termTypes, [.aa])
    termTypes = [.aa, .ab, .ac, .ab, .di, .ab]
    result = builder.setTermTypes(termTypes).build()
    XCTAssertEqual(result.termTypes.count, 4)
    XCTAssertEqual(result.termTypes, [.aa, .ab, .ac, .di])
  }

  func testSetEmptyTermTypes() throws {
    var result = builder.setTermTypes([.aa, .ab]).build()
    XCTAssertEqual(result.termTypes.count, 2)
    result = builder.setTermTypes([]).build()
    XCTAssertTrue(result.termTypes.isEmpty)
  }

  // Check if source is added and it's added at at last element in the list.
  func testAddNewSource() throws {
    let sourceVocabularies = UMLSSourceVocabulary.allCases[..<3]
    var result = builder.addSourceVocabulary(sourceVocabularies[0]).build()
    XCTAssertEqual(result.sourceVocabularies.count, 1)
    XCTAssertEqual(result.sourceVocabularies[0], sourceVocabularies[0])
    result = builder.addSourceVocabulary(sourceVocabularies[1]).build()
    XCTAssertEqual(result.sourceVocabularies.count, 2)
    XCTAssertEqual(result.sourceVocabularies[0], sourceVocabularies[0])
    XCTAssertEqual(result.sourceVocabularies[1], sourceVocabularies[1])
    result = builder.addSourceVocabulary(sourceVocabularies[2]).build()
    XCTAssertEqual(result.sourceVocabularies.count, 3)
    XCTAssertEqual(result.sourceVocabularies[0], sourceVocabularies[0])
    XCTAssertEqual(result.sourceVocabularies[1], sourceVocabularies[1])
    XCTAssertEqual(result.sourceVocabularies[2], sourceVocabularies[2])
  }

  func testAddDuplicateSource() throws {
    let _source = UMLSSourceVocabulary.random()
    let sourceVocabularies = (0..<3).map({ _ in _source })
    sourceVocabularies.forEach({ _ = builder.addSourceVocabulary($0) })
    let result = builder.build()
    XCTAssertEqual(result.sourceVocabularies.count, 1)
    XCTAssertEqual(result.sourceVocabularies[0], sourceVocabularies[0])
  }

  func testRemoveExistingSource() throws {
    let sourceVocabularies = UMLSSourceVocabulary.allCases[..<3]
    sourceVocabularies.forEach({ _ = builder.addSourceVocabulary($0) })
    var result = builder.removeSourceVocabulary(sourceVocabularies[0]).build()
    XCTAssertEqual(result.sourceVocabularies.count, 2)
    XCTAssertEqual(result.sourceVocabularies[0], sourceVocabularies[1])
    XCTAssertEqual(result.sourceVocabularies[1], sourceVocabularies[2])
    result = builder.removeSourceVocabulary(sourceVocabularies[1]).build()
    XCTAssertEqual(result.sourceVocabularies.count, 1)
    XCTAssertEqual(result.sourceVocabularies[0], sourceVocabularies[2])
    result = builder.removeSourceVocabulary(sourceVocabularies[2]).build()
    XCTAssertEqual(result.sourceVocabularies.count, 0)
  }

  func testRemoveNonExistingSource() throws {
    UMLSSourceVocabulary
      .allCases[..<3]
      .forEach({ _ = builder.addSourceVocabulary($0) })
    var result = builder.build()
    XCTAssertEqual(result.sourceVocabularies.count, 3)
    result = builder.removeSourceVocabulary(.allCases[3]).build()
    XCTAssertEqual(result.sourceVocabularies.count, 3)
  }

  func testRemoveSourceFromEmptyList() throws {
    // By default the sources is an empty list.
    let result = builder.removeSourceVocabulary(.random()).build()
    XCTAssertTrue(result.sourceVocabularies.isEmpty)
  }

  func testSetUniqueSources() throws {
    var sources = Array(UMLSSourceVocabulary.allCases[..<3])
    var result = builder.setSourceVocabularies(sources).build()
    XCTAssertEqual(result.sourceVocabularies.count, 3)
    XCTAssertEqual(result.sourceVocabularies, sources)
    sources = Array(UMLSSourceVocabulary.allCases[3..<6])
    result = builder.setSourceVocabularies(sources).build()
    XCTAssertEqual(result.sourceVocabularies.count, 3)
    XCTAssertEqual(result.sourceVocabularies, sources)
  }

  func testSetDuplicateSources() throws {
    let _source = UMLSSourceVocabulary.random()
    let sources = (0..<3).map({ _ in _source })
    let result = builder.setSourceVocabularies(sources).build()
    XCTAssertEqual(result.sourceVocabularies.count, 1)
    XCTAssertEqual(result.sourceVocabularies[0], _source)
  }

  func testSetEmptySources() throws {
    _ =
      builder
      .setSourceVocabularies(
        (0..<3).map({ _ in UMLSSourceVocabulary.random() })
      )
    XCTAssertGreaterThan(builder.build().sourceVocabularies.count, 0)
    let result = builder.setSourceVocabularies([]).build()
    XCTAssertEqual(result.sourceVocabularies.count, 0)
  }

}
