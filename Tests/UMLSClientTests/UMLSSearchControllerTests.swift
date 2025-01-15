// UMLSSearchControllerTests.swift
// Test search controller components.

import XCTest
@testable import UMLSClient

final class UMLSVersionTests: XCTestCase {

    func testVersionDescription() throws {
        let dict: [String: (UMLSVersion.ReleaseYear, UMLSVersion.Release)] = [
            "2008AA": (.year2008, .AA),
            "2008AB": (.year2008, .AB),
            "2009AA": (.year2009, .AA),
            "2009AB": (.year2009, .AB),
            "2010AA": (.year2010, .AA),
            "2010AB": (.year2010, .AB),
            "2011AA": (.year2011, .AA),
            "2011AB": (.year2011, .AB),
            "2012AA": (.year2012, .AA),
            "2012AB": (.year2012, .AB),
            "2013AA": (.year2013, .AA),
            "2013AB": (.year2013, .AB),
            "2014AA": (.year2014, .AA),
            "2014AB": (.year2014, .AB),
            "2015AA": (.year2015, .AA),
            "2015AB": (.year2015, .AB),
            "2016AA": (.year2016, .AA),
            "2016AB": (.year2016, .AB),
            "2017AA": (.year2017, .AA),
            "2017AB": (.year2017, .AB),
            "2018AA": (.year2018, .AA),
            "2018AB": (.year2018, .AB),
            "2019AA": (.year2019, .AA),
            "2019AB": (.year2019, .AB),
            "2020AA": (.year2020, .AA),
            "2020AB": (.year2020, .AB),
            "2021AA": (.year2021, .AA),
            "2021AB": (.year2021, .AB),
            "2022AA": (.year2022, .AA),
            "2022AB": (.year2022, .AB),
            "2023AA": (.year2023, .AA),
            "2023AB": (.year2023, .AB),
            "2024AA": (.year2024, .AA),
            "2024AB": (.year2024, .AB),
        ]
        dict.forEach { set in
            XCTAssertEqual(UMLSVersion(year: set.value.0, release: set.value.1).description, set.key)
        }
    }

    func testInitializeWithString() throws {
        let dict: [String: UMLSVersion] = [
            "2008AA": UMLSVersion(year: .year2008, release: .AA),
            "2008AB": UMLSVersion(year: .year2008, release: .AB),
            "2009AA": UMLSVersion(year: .year2009, release: .AA),
            "2009AB": UMLSVersion(year: .year2009, release: .AB),
            "2010AA": UMLSVersion(year: .year2010, release: .AA),
            "2010AB": UMLSVersion(year: .year2010, release: .AB),
            "2011AA": UMLSVersion(year: .year2011, release: .AA),
            "2011AB": UMLSVersion(year: .year2011, release: .AB),
            "2012AA": UMLSVersion(year: .year2012, release: .AA),
            "2012AB": UMLSVersion(year: .year2012, release: .AB),
            "2013AA": UMLSVersion(year: .year2013, release: .AA),
            "2013AB": UMLSVersion(year: .year2013, release: .AB),
            "2014AA": UMLSVersion(year: .year2014, release: .AA),
            "2014AB": UMLSVersion(year: .year2014, release: .AB),
            "2015AA": UMLSVersion(year: .year2015, release: .AA),
            "2015AB": UMLSVersion(year: .year2015, release: .AB),
            "2016AA": UMLSVersion(year: .year2016, release: .AA),
            "2016AB": UMLSVersion(year: .year2016, release: .AB),
            "2017AA": UMLSVersion(year: .year2017, release: .AA),
            "2017AB": UMLSVersion(year: .year2017, release: .AB),
            "2018AA": UMLSVersion(year: .year2018, release: .AA),
            "2018AB": UMLSVersion(year: .year2018, release: .AB),
            "2019AA": UMLSVersion(year: .year2019, release: .AA),
            "2019AB": UMLSVersion(year: .year2019, release: .AB),
            "2020AA": UMLSVersion(year: .year2020, release: .AA),
            "2020AB": UMLSVersion(year: .year2020, release: .AB),
            "2021AA": UMLSVersion(year: .year2021, release: .AA),
            "2021AB": UMLSVersion(year: .year2021, release: .AB),
            "2022AA": UMLSVersion(year: .year2022, release: .AA),
            "2022AB": UMLSVersion(year: .year2022, release: .AB),
            "2023AA": UMLSVersion(year: .year2023, release: .AA),
            "2023AB": UMLSVersion(year: .year2023, release: .AB),
            "2024AA": UMLSVersion(year: .year2024, release: .AA),
            "2024AB": UMLSVersion(year: .year2024, release: .AB)
        ]
        try dict.forEach { set in
            XCTAssertEqual(try UMLSVersion(string: set.key), set.value)
        }
    }

    func testInitializeWithInvalidStringSize() throws {
        [1, 2, 3, 4, 5, 7, 8, 9, 10]
            .map(randomString(length:))
            .forEach { string in
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
        (0..<100)
            .map({ _ in randomString(length: 4) })
            .map({ $0 + "AA" })
            .forEach { string in
                do {
                    _ = try UMLSVersion(string: string)
                    XCTFail("UMLSVersion string initializer does not raise error for string: \(string)")
                } catch let error as UMLSVersion.VersionStringError {
                    XCTAssertEqual(error, .invalidYear(string: String(string[...String.Index(utf16Offset: 3, in: string)])))
                } catch {
                    XCTFail("Unexpected error: \(error)")
                }
            }
    }

    func testInitializeWithUnsupportedYearPart() throws {
        // 1990 to 2007
        (1990...2007)
            .map({ ($0, "\($0)AA") })
            .forEach { set in
                do {
                    _ = try UMLSVersion(string: set.1)
                } catch let error as UMLSVersion.VersionStringError {
                    XCTAssertEqual(error, .unsupportedYear(year: set.0))
                } catch {
                    XCTFail("Unexpected error: \(error)")
                }
            }
        // 2025 to 3000
        (2025...3000)
            .map({ ($0, "\($0)AA") })
            .forEach { set in
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
        (2008...2024)
            .map({ int in
                let str = randomString(length: 2)
                return (str, "\(int)\(str)")
            })
            .forEach { set in
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
        searchController = UMLSClient(baseURL: host, apiKey: apiKey, version: version).searchController()
    }

    override func tearDown() async throws {
        self.searchController = nil
    }

    func testCompleteWordSearch() async throws {
        let result = try await searchController.search(UMLSSearchParametersBuilder(randomString(length: 10)).build())
        XCTAssertGreaterThan(result.number, 0)
        XCTAssertGreaterThan(result.size, 0)
        XCTAssertGreaterThan(result.count, 0)
        XCTAssertGreaterThan(result.elements.count, 0)
    }

    func testPartialWordSearch() async throws {
        let builder = try UMLSSearchParametersBuilder(randomString(length: 10))
            .setPartialSearch(true)
        let result = try await searchController.search(builder.build())
        XCTAssertGreaterThan(result.number, 0)
        XCTAssertGreaterThan(result.size, 0)
        XCTAssertGreaterThan(result.count, 0)
        XCTAssertGreaterThan(result.elements.count, 0)
    }

    func testCompleteExactSearch() async throws {
        let builder = try UMLSSearchParametersBuilder(randomString(length: 10))
            .setSearchType(.exact)
        let result = try await searchController.search(builder.build())
        XCTAssertGreaterThan(result.number, 0)
        XCTAssertGreaterThan(result.size, 0)
        XCTAssertGreaterThan(result.count, 0)
        XCTAssertGreaterThan(result.elements.count, 0)
    }

    func testParticalExactSearch() async throws {
        let builder = try UMLSSearchParametersBuilder(randomString(length: 10))
            .setSearchType(.exact)
            .setPartialSearch(true)
        let result = try await searchController.search(builder.build())
        XCTAssertGreaterThan(result.number, 0)
        XCTAssertGreaterThan(result.size, 0)
        XCTAssertGreaterThan(result.count, 0)
        XCTAssertGreaterThan(result.elements.count, 0)
    }

}
