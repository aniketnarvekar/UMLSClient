//  UMLSConceptRelationParametersBuilderTests.swift

import UMLSClient
import XCTest

final class UMLSConceptRelationParametersBuilderTests: XCTestCase {

  var builder: UMLSConceptRelationParametersBuilder!

  override func setUp() {
    builder = .init(concept: .random())
  }

  func testWithDefault() throws {
    let concept: UMLSUI<UMLSConcept> = .random()
    builder = UMLSConceptRelationParametersBuilder(concept: concept)
    let result = builder.build()
    XCTAssertEqual(result.concept, concept)
    XCTAssertTrue(result.relationLabels.isEmpty)
    XCTAssertTrue(result.additionalRelationLabels.isEmpty)
    XCTAssertFalse(result.includeObsolete)
    XCTAssertFalse(result.includeSuppressible)
    XCTAssertEqual(result.page, .init())
    XCTAssertTrue(result.sourceVocabularies.isEmpty)
  }

  // Ensure obsolete terms are included indication
  func testIncludeObsolete() throws {
    let result =
      builder
      .setIncludeObsolete(true)
      .build()
    XCTAssertEqual(result.includeObsolete, true)
  }

  // Ensure obsolete terms are included
  func testIncludeSuppressible() throws {
    let result =
      builder
      .setIncludeSuppressible(true)
      .build()
    XCTAssertEqual(result.includeSuppressible, true)
  }

  func testPageSizeGreaterThanZero() throws {
    let result =
      builder
      .setPageInfo(.init(size: .random(in: 1...UInt.max)))
      .build()
    XCTAssertGreaterThan(result.page.size, 0)
  }

  func testPageSizeEqualToZero() throws {
    let result =
      builder
      .setPageInfo(.init(size: 0))
      .build()
    XCTAssertEqual(result.page.size, PageInfo.defaultSize)
  }

  func testPageNumberGreaterThanZero() throws {
    let result =
      builder
      .setPageInfo(.init(number: .random(in: 1...UInt.max)))
      .build()
    XCTAssertGreaterThan(result.page.number, 0)
  }

  func testPageNumberEqualToZero() throws {
    let result =
      builder
      .setPageInfo(.init(number: 0))
      .build()
    XCTAssertEqual(result.page.number, PageInfo.defaultNumber)
  }

  func testAddUniqueRelationLabel() throws {
    let labels = UMLSRelationLabel.allCases
    labels.forEach({ _ = builder.addRelationLabel($0) })
    let result = builder.build()
    XCTAssertEqual(result.relationLabels.count, 15)
    XCTAssertEqual(result.relationLabels, labels)
  }

  func testAddDuplicateRelationLabel() throws {
    let labels = UMLSRelationLabel.allCases
    labels.forEach({ _ = builder.addRelationLabel($0) })
    let result = builder.build()
    XCTAssertEqual(result.relationLabels.count, 15)
    XCTAssertEqual(result.relationLabels, labels)
  }

  func testRemoveExistingRelationLabel() throws {
    let labels = UMLSRelationLabel.allCases
    labels.forEach({ _ = builder.addRelationLabel($0) })
    // Remove first element from the list.
    var result = builder.removeRelationLabel(labels[0]).build()
    XCTAssertEqual(result.relationLabels.count, 14)
    XCTAssertEqual(result.relationLabels[0], labels[1])
    // remove lst element formt the list.
    result = builder.removeRelationLabel(labels[14]).build()
    XCTAssertEqual(result.relationLabels.count, 13)
    XCTAssertEqual(result.relationLabels[12], labels[13])
    // remove element from middle
    result = builder.removeRelationLabel(labels[4]).build()
    XCTAssertEqual(result.relationLabels.count, 12)
    XCTAssertEqual(result.relationLabels[4], labels[6])
  }

  func testRemoveNonExistingRelationLabel() throws {
    UMLSRelationLabel.allCases[..<10].forEach({ _ = builder.addRelationLabel($0) })
    let label = UMLSRelationLabel.allCases[10...].randomElement()!
    let result = builder.removeRelationLabel(label).build()
    XCTAssertEqual(result.relationLabels.count, 10)
  }

  func testSetUniqueRelationLabels() throws {
    let labels = UMLSRelationLabel.allCases
    let result = builder.setRelationLabels(labels).build()
    XCTAssertEqual(result.relationLabels.count, 15)
    XCTAssertEqual(result.relationLabels, labels)
  }

  func testSetDuplicateRelationLabels() throws {
    let label = UMLSRelationLabel.random()
    let labels = (0..<10).map({ _ in label })
    let result = builder.setRelationLabels(labels).build()
    XCTAssertEqual(result.relationLabels.count, 1)
    XCTAssertEqual(result.relationLabels[0], label)
  }

  func testAddSingleAdditionalRelationLabel() throws {
    let label = UMLSAdditionalRelationLabel.random()

    let result =
      builder
      .addAdditionalRelationLabel(label)
      .build()

    XCTAssertEqual(result.additionalRelationLabels.count, 1)
    XCTAssertEqual(result.additionalRelationLabels[0], label)

  }

  func testAddUniqueMultipleAdditionalRelationLabel() throws {
    let labels = UMLSAdditionalRelationLabel.allCases
    labels.forEach({ _ = builder.addAdditionalRelationLabel($0) })
    let result = builder.build()
    XCTAssertEqual(result.additionalRelationLabels.count, labels.count)
    XCTAssertEqual(result.additionalRelationLabels, labels)
  }

  func testAddDuplicateAdditionalRelationLabel() throws {
    let label = UMLSAdditionalRelationLabel.random()
    (0..<10)
      .forEach({ _ in _ = builder.addAdditionalRelationLabel(label) })
    let result = builder.build()
    XCTAssertEqual(result.additionalRelationLabels.count, 1)
    XCTAssertEqual(result.additionalRelationLabels[0], label)
  }

  func testRemoveExistingAdditionalRelationLabel() throws {
    UMLSAdditionalRelationLabel.allCases
      .forEach({ _ = builder.addAdditionalRelationLabel($0) })
    let label = UMLSAdditionalRelationLabel.random()
    let result =
      builder
      .removeAdditionalRelationLabel(label)
      .build()

    XCTAssertEqual(result.additionalRelationLabels.count, 1009)
    XCTAssertFalse(result.additionalRelationLabels.contains(label))
  }

  func testRemoveAbsentAdditionalRelationLabel() throws {

    UMLSAdditionalRelationLabel.allCases[..<100]
      .forEach({ _ = builder.addAdditionalRelationLabel($0) })
    let label = UMLSAdditionalRelationLabel.allCases[100...].randomElement()!
    let result =
      builder
      .removeAdditionalRelationLabel(label)
      .build()

    XCTAssertEqual(result.additionalRelationLabels.count, 100)

  }

  func testSetListOfUniqueAdditionalRelationLabels() throws {
    let labels = UMLSAdditionalRelationLabel.allCases
    let result =
      builder
      .setAdditionalRelationLabels(labels)
      .build()
    XCTAssertEqual(result.additionalRelationLabels.count, labels.count)
    XCTAssertEqual(result.additionalRelationLabels, labels)
  }

  func testSetListOfDuplicateAdditionalRelationLables() throws {
    let label = UMLSAdditionalRelationLabel.random()
    let labels = (0..<100).map({ _ in label })
    let result =
      builder
      .setAdditionalRelationLabels(labels)
      .build()
    XCTAssertEqual(result.additionalRelationLabels.count, 1)
    XCTAssertEqual(result.additionalRelationLabels.first!, label)
  }

  func testSetEmptyAdditionalRelationLables() throws {
    _ = builder.setAdditionalRelationLabels(UMLSAdditionalRelationLabel.allCases)

    let result = builder.setAdditionalRelationLabels([]).build()
    XCTAssertTrue(result.additionalRelationLabels.isEmpty)

  }

  func testAddNewSource() throws {
    let sabs = Array(UMLSSourceVocabulary.allCases[..<10])
    sabs.forEach({ _ = builder.addSourceVocabulary($0) })
    let result = builder.build()
    XCTAssertEqual(result.sourceVocabularies, sabs)
  }

  func testAddDuplicateSource() throws {
    let sab = UMLSSourceVocabulary.random()
    (0..<10)
      .map({ _ in sab })
      .forEach({ _ = builder.addSourceVocabulary($0) })
    let result = builder.build()
    XCTAssertEqual(result.sourceVocabularies.count, 1)
    XCTAssertEqual(result.sourceVocabularies[0], sab)
  }

  func testExistingRemoveSource() throws {
    let sources = (0..<10)
      .map({ _ in UMLSSourceVocabulary.random() })
    sources.forEach({ _ = builder.addSourceVocabulary($0) })

    var source = sources.randomElement()!
    var result =
      builder
      .removeSourceVocabulary(source)
      .build()
    XCTAssertFalse(result.sourceVocabularies.contains(source))

    source = sources.randomElement()!
    result =
      builder
      .removeSourceVocabulary(source)
      .build()
    XCTAssertFalse(result.sourceVocabularies.contains(source))
  }

  func testRemoveAbsentSource() throws {
    let sources = Array(UMLSSourceVocabulary.allCases[..<10])
    sources.forEach({ _ = builder.addSourceVocabulary($0) })

    let source = UMLSSourceVocabulary.allCases[10]
    XCTAssertFalse(sources.contains(source))
    let result =
      builder
      .removeSourceVocabulary(source)
      .build()
    XCTAssertFalse(result.sourceVocabularies.contains(source))
  }

  func testSetUniqueSource() throws {
    let sources: [UMLSSourceVocabulary] = [
      .aod,
      .air,
      .alt,
      .snmi,
      .aot,
      .atc,
      .bi,
      .ccc,
      .ccpss,
      .ccsrIcd10cm,
    ]
    let result = builder.setSourceVocabulary(sources).build()
    XCTAssertEqual(result.sourceVocabularies, sources)
  }

  func testSetDuplicateSource() throws {
    let source = UMLSSourceVocabulary.random()
    let sources = (0..<10)
      .map({ _ in source })
    let result = builder.setSourceVocabulary(sources)
      .build()
    XCTAssertEqual(result.sourceVocabularies.count, 1)
    XCTAssertEqual(result.sourceVocabularies[0], source)
  }

}
