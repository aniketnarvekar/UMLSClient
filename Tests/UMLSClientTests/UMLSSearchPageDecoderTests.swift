//  UMLSSearchPageDecoderTests.swift

import XCTest
@testable import UMLSClient

final class UMLSSearchPageDecoderTests: XCTestCase {

    var decoder: JSONDecoder!

    override func setUp() {
        self.decoder = JSONDecoder()
    }

    func testASearchElement() throws {
        let data = try stubData(forResource: "SearchElement", withExtension: "json")
        let object = try decoder.decode(UMLSSearchElement.self, from: data)
        XCTAssertEqual(object.id, "D000141")
        XCTAssertEqual(object.source, "MSH")
        XCTAssertEqual(object.name, "Acidosis, Renal Tubular")
    }

    func testSearchPage() throws {
        let data = try stubData(forResource: "SearchResultPage", withExtension: "json")
        let object = try decoder.decode(UMLSSearchPage.self, from: data)
        XCTAssertEqual(object.size, 25)
        XCTAssertEqual(object.number, 1)
        XCTAssertEqual(object.count, 7)
        XCTAssertEqual(object.elements.count, object.size)

        let first = object.elements.first!
        XCTAssertEqual(first.id, "D000141")
        XCTAssertEqual(first.name, "Acidosis, Renal Tubular")
        XCTAssertEqual(first.source, "MSH")

        let last = object.elements.last!
        XCTAssertEqual(last.id, "0623")
        XCTAssertEqual(last.name, "TUBULO RENAL, TRASTORNO")
        XCTAssertEqual(last.source, "WHOSPA")
    }

}
