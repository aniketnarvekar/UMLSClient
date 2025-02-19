// UMLSSearchControllerTests.swift
// Test search controller components.

import XCTest

@testable import UMLSClient

final class UMLSVersionTests: XCTestCase {

  func testVersionDescription() throws {
    let dict: [String: (UMLSVersion.ReleaseYear, UMLSVersion.Release)] = [
      "2008AA": (.year2008, .aa),
      "2008AB": (.year2008, .ab),
      "2009AA": (.year2009, .aa),
      "2009AB": (.year2009, .ab),
      "2010AA": (.year2010, .aa),
      "2010AB": (.year2010, .ab),
      "2011AA": (.year2011, .aa),
      "2011AB": (.year2011, .ab),
      "2012AA": (.year2012, .aa),
      "2012AB": (.year2012, .ab),
      "2013AA": (.year2013, .aa),
      "2013AB": (.year2013, .ab),
      "2014AA": (.year2014, .aa),
      "2014AB": (.year2014, .ab),
      "2015AA": (.year2015, .aa),
      "2015AB": (.year2015, .ab),
      "2016AA": (.year2016, .aa),
      "2016AB": (.year2016, .ab),
      "2017AA": (.year2017, .aa),
      "2017AB": (.year2017, .ab),
      "2018AA": (.year2018, .aa),
      "2018AB": (.year2018, .ab),
      "2019AA": (.year2019, .aa),
      "2019AB": (.year2019, .ab),
      "2020AA": (.year2020, .aa),
      "2020AB": (.year2020, .ab),
      "2021AA": (.year2021, .aa),
      "2021AB": (.year2021, .ab),
      "2022AA": (.year2022, .aa),
      "2022AB": (.year2022, .ab),
      "2023AA": (.year2023, .aa),
      "2023AB": (.year2023, .ab),
      "2024AA": (.year2024, .aa),
      "2024AB": (.year2024, .ab),
    ]

    for dict in dict {
      XCTAssertEqual(UMLSVersion(year: dict.value.0, release: dict.value.1).description, dict.key)
    }
  }

  func testInitializeWithString() throws {
    let dict: [String: UMLSVersion] = [
      "2008AA": UMLSVersion(year: .year2008, release: .aa),
      "2008AB": UMLSVersion(year: .year2008, release: .ab),
      "2009AA": UMLSVersion(year: .year2009, release: .aa),
      "2009AB": UMLSVersion(year: .year2009, release: .ab),
      "2010AA": UMLSVersion(year: .year2010, release: .aa),
      "2010AB": UMLSVersion(year: .year2010, release: .ab),
      "2011AA": UMLSVersion(year: .year2011, release: .aa),
      "2011AB": UMLSVersion(year: .year2011, release: .ab),
      "2012AA": UMLSVersion(year: .year2012, release: .aa),
      "2012AB": UMLSVersion(year: .year2012, release: .ab),
      "2013AA": UMLSVersion(year: .year2013, release: .aa),
      "2013AB": UMLSVersion(year: .year2013, release: .ab),
      "2014AA": UMLSVersion(year: .year2014, release: .aa),
      "2014AB": UMLSVersion(year: .year2014, release: .ab),
      "2015AA": UMLSVersion(year: .year2015, release: .aa),
      "2015AB": UMLSVersion(year: .year2015, release: .ab),
      "2016AA": UMLSVersion(year: .year2016, release: .aa),
      "2016AB": UMLSVersion(year: .year2016, release: .ab),
      "2017AA": UMLSVersion(year: .year2017, release: .aa),
      "2017AB": UMLSVersion(year: .year2017, release: .ab),
      "2018AA": UMLSVersion(year: .year2018, release: .aa),
      "2018AB": UMLSVersion(year: .year2018, release: .ab),
      "2019AA": UMLSVersion(year: .year2019, release: .aa),
      "2019AB": UMLSVersion(year: .year2019, release: .ab),
      "2020AA": UMLSVersion(year: .year2020, release: .aa),
      "2020AB": UMLSVersion(year: .year2020, release: .ab),
      "2021AA": UMLSVersion(year: .year2021, release: .aa),
      "2021AB": UMLSVersion(year: .year2021, release: .ab),
      "2022AA": UMLSVersion(year: .year2022, release: .aa),
      "2022AB": UMLSVersion(year: .year2022, release: .ab),
      "2023AA": UMLSVersion(year: .year2023, release: .aa),
      "2023AB": UMLSVersion(year: .year2023, release: .ab),
      "2024AA": UMLSVersion(year: .year2024, release: .aa),
      "2024AB": UMLSVersion(year: .year2024, release: .ab),
    ]

    for dict in dict {
      XCTAssertEqual(try UMLSVersion(string: dict.key), dict.value)
    }
  }

  func testInitializeWithInvalidStringSize() throws {
    let strings = [1, 2, 3, 4, 5, 7, 8, 9, 10]
      .map(String.randomAlphaNumericString(of:))

    for string in strings {
      do {
        _ = try UMLSVersion(string: string)
        XCTFail("UMLSVersion string initializer does not raise error for string: \(string)")
      } catch let error as UMLSVersion.VersionStringError {
        XCTAssertEqual(error, .invalidlength)
      } catch {
        XCTFail("Unexpected error: \(error)")
      }
    }
  }

  func testInitiallizeWithIllFormedYearPart() throws {
    let strings = (0..<100)
      .map({ _ in String.randomAlphaNumericString(of: 4) })

    for string in strings {
      try XCTSkipIf(!string.contains(where: { !$0.isNumber }))
      do {
        _ = try UMLSVersion(string: string + "AA")
        XCTFail("UMLSVersion string initializer does not raise error for string: \(string)")
      } catch let error as UMLSVersion.VersionStringError {
        XCTAssertEqual(
          error, .invalidYear(string: String(string[...String.Index(utf16Offset: 3, in: string)]))
        )
      } catch {
        XCTFail("Unexpected error: \(error)")
      }
    }
  }

  func testInitializeWithUnsupportedYearPart() throws {
    // 1990 to 2007
    var sets = (1990...2007)
      .map({ ($0, "\($0)AA") })

    for set in sets {
      do {
        _ = try UMLSVersion(string: set.1)
      } catch let error as UMLSVersion.VersionStringError {
        XCTAssertEqual(error, .unsupportedYear(year: set.0))
      } catch {
        XCTFail("Unexpected error: \(error)")
      }
    }
    // 2025 to 3000
    sets = (2025...3000)
      .map({ ($0, "\($0)AA") })

    for set in sets {
      do {
        _ = try UMLSVersion(string: set.1)
      } catch let error as UMLSVersion.VersionStringError {
        XCTAssertEqual(error, .unsupportedYear(year: set.0))
      } catch {
        XCTFail("Unexpected error: \(error)")
      }
    }
  }

  func testInitializeWithUnsupportedRelease() throws {
    let sets = (2008...2024)
      .map({ int in
        let str = String.randomAlphaNumericString(of: 2)
        return (str, "\(int)\(str)")
      })

    for set in sets {
      do {
        _ = try UMLSVersion(string: set.1)
      } catch let error as UMLSVersion.VersionStringError {
        XCTAssertEqual(error, .unsupportedRelease(release: set.0))
      } catch {
        XCTFail("Unexpected error: \(error)")
      }
    }
  }

}

final class SearchErrorInfoTests: XCTestCase {

  var decoder: JSONDecoder!

  override func setUp() {
    super.setUp()
    self.decoder = .init()
  }

  func testDecodeSearchErrorInfo() throws {
    let data = try stubData(forResource: "MissingStringResponse", withExtension: "json")
    let object = try decoder.decode(SearchErrorInfo.self, from: data)
    XCTAssertEqual(object.code, "ValidationError")
    XCTAssertEqual(object.message, "Missing 'string'")
  }

  func testDecodeInvalidSearchErrorInfoCode() throws {
    let data = """
      {
          "code": "ValidationError",
          "status": 400,
          "message": "Missing 'string'"
      }
      """.data(using: .utf8)!

    do {
      _ = try decoder.decode(SearchErrorInfo.self, from: data)
    } catch let error as DecodingError {
      switch error {
      case .keyNotFound(let key, _):
        XCTAssertEqual(key.stringValue, "name")
      default:
        XCTFail("Unexpected Error: \(error)")
      }
    }
  }

  func testDecodeinvalidSearchErrorInfoMessage() throws {
    let data = """
      {
          "name": "ValidationError",
          "status": 400,
          "msg": "Missing 'string'"
      }
      """.data(using: .utf8)!

    do {
      _ = try decoder.decode(SearchErrorInfo.self, from: data)
    } catch let error as DecodingError {
      switch error {
      case .keyNotFound(let key, _):
        XCTAssertEqual(key.stringValue, "message")
      default:
        XCTFail("Unexpected Error: \(error)")
      }
    }

  }

}

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
