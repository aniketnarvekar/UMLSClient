//  UMLSSemanticTypeDecodingTests.swift

import XCTest
import UMLSClient

final class UMLSSemanticTypeDecodingTests: XCTestCase {

    var decoder: JSONDecoder!

    override func setUp() {
        self.decoder = .init()
    }

    func testWithValidJSON() throws {
        let jsonData = """
{"name": "Disease or Syndrome"}
""".data(using: .utf8)!
        let semanticType = try decoder.decode(UMLSSemanticType.self, from: jsonData)
        XCTAssertEqual(semanticType.name, "Disease or Syndrome")
    }

    func testWithEmptyName() throws {
        let jsonData = """
{"name": ""}
""".data(using: .utf8)!
        do {
            _ = try decoder.decode(UMLSSemanticType.self, from: jsonData)
        } catch let error as DecodingError {
            switch error {
            case .dataCorrupted(let context):
                XCTAssertEqual(context.codingPath[0].stringValue, "name")
            default:
                XCTFail("Unexpected decoding error: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testMissingNameKey() {
        let jsonData = "{}".data(using: .utf8)!
        do {
            _ = try decoder.decode(UMLSSemanticType.self, from: jsonData)
        } catch let error as DecodingError {
            switch error {
            case .keyNotFound(let coding, _):
                XCTAssertEqual(coding.stringValue, "name")
            default:
                XCTFail("Unexpected decoding error: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

}
