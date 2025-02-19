// UMLSSearchParametersTests.swift
// Test UMLS search parameters

import XCTest

@testable import UMLSClient

enum StubError: Error {
  case resourceNotFount(name: String, extension: String)
}

func stubData(
  forResource name: String,
  withExtension ext: String
) throws -> Data {
  guard
    let url = Bundle.module.url(forResource: name, withExtension: ext)
  else {
    throw StubError.resourceNotFount(name: name, extension: ext)
  }
  return try Data(contentsOf: url)
}

final class UMLSSearchParametersTests: XCTestCase {

  override class func setUp() {
    super.setUp()
  }

  func testEmptySearchParameterInitializer() throws {
    do {
      let unexpectedSearchParameter = try UMLSSearchParametersBuilder("").build()
      XCTFail("Unexpected search parameters: \(unexpectedSearchParameter)")
    } catch let error as UMLSSearchParametersBuilder.BuildError {
      XCTAssertEqual(error, UMLSSearchParametersBuilder.BuildError.emptySearchString)
    } catch {
      XCTFail("unexpected Error: \(error)")
    }
  }

  func testDefaultSearchParameters() throws {
    let searchString = String.randomAlphaNumericString(of: 100)
    let searchParameters = try! UMLSSearchParametersBuilder(searchString).build()
    XCTAssertEqual(searchParameters.string, searchString)
    XCTAssertEqual(searchParameters.inputType, UMLSSearchInputType.atom)
    XCTAssertEqual(searchParameters.includeObsolete, false)
    XCTAssertEqual(searchParameters.includeSuppressible, false)
    XCTAssertEqual(searchParameters.returnIdType, UMLSSearchReturnIDType.concept)
    XCTAssertEqual(searchParameters.sourceVocabularies, [])
    XCTAssertEqual(searchParameters.searchType, UMLSSearchType.words)
    XCTAssertEqual(searchParameters.partialSearch, false)
    XCTAssertEqual(searchParameters.pageNumber, 1)
    XCTAssertEqual(searchParameters.pageSize, 25)
  }

  func testSetEmptySearchString() throws {
    let searchString = String.randomAlphaNumericString(of: 100)
    let searchParameterBuilder = try UMLSSearchParametersBuilder(searchString)
    do {
      _ = try searchParameterBuilder.setSearchText("")
    } catch let error as UMLSSearchParametersBuilder.BuildError {
      XCTAssertEqual(error, .emptySearchString)
    } catch {
      XCTFail("unexpected Error: \(error)")
    }
  }

  func testSetSearchString() throws {
    var searchString = String.randomAlphaNumericString(of: 10)
    var searchParametersBuilder = try UMLSSearchParametersBuilder(searchString)
    XCTAssertEqual(searchParametersBuilder.build().string, searchString)
    searchString = String.randomAlphaNumericString(of: 10)
    searchParametersBuilder = try searchParametersBuilder.setSearchText(searchString)
    XCTAssertEqual(searchParametersBuilder.build().string, searchString)
  }

  func testSetSearchInputType() throws {
    let searchParameterBuilder = try UMLSSearchParametersBuilder(
      String.randomAlphaNumericString(of: 10))
    let inputTypes: [UMLSSearchInputType] = [
      .atom, .code, .sourceConcept, .sourceDescriptor, .sourceUI, .tty,
    ]
    inputTypes.forEach({ inputType in
      let searchParameters = searchParameterBuilder.setInputType(inputType).build()
      XCTAssertEqual(searchParameters.inputType, inputType)
    })
  }

  func testSetIncludeAbsolute() throws {
    let searchParameterBuilder = try UMLSSearchParametersBuilder(
      String.randomAlphaNumericString(of: 10))
    let bools = [true, false]
    bools.forEach { bool in
      let searchParameters = searchParameterBuilder.setIncludeObsolete(bool).build()
      XCTAssertEqual(searchParameters.includeObsolete, bool)
    }
  }

  func testSetIncludeSuppressible() throws {
    let searchParameterBuilder = try UMLSSearchParametersBuilder(
      String.randomAlphaNumericString(of: 10))
    let bools = [true, false]
    bools.forEach { bool in
      let searchParameters = searchParameterBuilder.setIncludeSuppressible(bool).build()
      XCTAssertEqual(searchParameters.includeSuppressible, bool)
    }
  }

  func testSourceVocabularies() throws {
    let searchParameterBuilder = try UMLSSearchParametersBuilder(
      String.randomAlphaNumericString(of: 10))
    XCTAssertTrue(searchParameterBuilder.build().sourceVocabularies.isEmpty)
    let sourceVocabulary = UMLSSourceVocabulary.random()
    let searchParameters = try searchParameterBuilder.addSourceVocabulary(sourceVocabulary).build()
    XCTAssertEqual(searchParameters.sourceVocabularies.count, 1)
    XCTAssertEqual(searchParameters.sourceVocabularies.first, sourceVocabulary)
    XCTAssertTrue(
      searchParameterBuilder.removeSourceVocabulary(sourceVocabulary).build().sourceVocabularies
        .isEmpty)
    let sourceVocabularies = UMLSSourceVocabulary.allCases[..<3]
    XCTAssertEqual(
      try sourceVocabularies.map({ try searchParameterBuilder.addSourceVocabulary($0) }).last!
        .build().sourceVocabularies.count,
      3
    )
  }

  func testSetSearchType() throws {
    let searchParameterBuilder = try UMLSSearchParametersBuilder(
      String.randomAlphaNumericString(of: 10))
    let searchTypes: [UMLSSearchType] = [
      .exact, .leftTruncation, .normalizedString, .normalizedWords, .rightTruncation, .words,
    ]
    searchTypes.forEach({ searchType in
      XCTAssertEqual(
        searchParameterBuilder.setSearchType(searchType).build().searchType, searchType)
    })
  }

  func testSetPartialSearch() throws {
    let searchParameterBuilder = try UMLSSearchParametersBuilder(
      String.randomAlphaNumericString(of: 10))
    let bools: [Bool] = [true, false]
    bools.forEach { bool in
      XCTAssertEqual(searchParameterBuilder.setPartialSearch(bool).build().partialSearch, bool)
    }
  }

  func testSetPageSizeGreaterThenZero() throws {
    let searchParameterBuilder = try UMLSSearchParametersBuilder(
      String.randomAlphaNumericString(of: 10))
    let pageSize = Int.random(in: 0...100)
    let searchParameter = try searchParameterBuilder.setPageSize(pageSize).build()
    XCTAssertEqual(searchParameter.pageSize, pageSize)
  }

  func testSetPageSizeLessThenZero() throws {
    let searchParameterBuilder = try UMLSSearchParametersBuilder(
      String.randomAlphaNumericString(of: 10))
    let negNumber = Int.random(in: Int.min..<0)
    do {
      _ = try searchParameterBuilder.setPageSize(negNumber)
    } catch let error as UMLSSearchParametersBuilder.BuildError {
      XCTAssertEqual(error, .invalidPageSize(number: negNumber))
    } catch {
      XCTFail("Unexpected Error: \(error.localizedDescription)")
    }
  }

  func testSetPageSizeEqualToZero() throws {
    let searchParameterBuilder = try UMLSSearchParametersBuilder(
      String.randomAlphaNumericString(of: 10))
    do {
      _ = try searchParameterBuilder.setPageSize(0)
    } catch let error as UMLSSearchParametersBuilder.BuildError {
      XCTAssertEqual(error, .invalidPageSize(number: 0))
    } catch {
      XCTFail("Unexpected Error: \(error)")
    }
  }

  func testSetPageNumberGreaterThenZero() throws {
    let searchParameterBuilder = try UMLSSearchParametersBuilder(
      String.randomAlphaNumericString(of: 10))
    let pageNumber = Int.random(in: 0...100)
    let searchParameters = try searchParameterBuilder.setPageNumber(pageNumber).build()
    XCTAssertEqual(searchParameters.pageNumber, pageNumber)
  }

  func testSetPageNumberLessThenZero() throws {
    let searchParameterBuilder = try UMLSSearchParametersBuilder(
      String.randomAlphaNumericString(of: 10))
    let negNumber = Int.random(in: Int.min..<0)
    do {
      _ = try searchParameterBuilder.setPageNumber(negNumber).build()
    } catch let error as UMLSSearchParametersBuilder.BuildError {
      XCTAssertEqual(error, .invalidPageNumber(number: negNumber))
    } catch {
      XCTFail("Unexpected Error: \(error)")
    }
  }

  func testSetPageNumberEqualToZero() throws {
    let searchParameterBuilder = try UMLSSearchParametersBuilder(
      String.randomAlphaNumericString(of: 10))
    do {
      _ = try searchParameterBuilder.setPageNumber(0)
    } catch let error as UMLSSearchParametersBuilder.BuildError {
      XCTAssertEqual(error, .invalidPageNumber(number: 0))
    } catch {
      XCTFail("Unexpected Error: \(error)")
    }
  }

}
