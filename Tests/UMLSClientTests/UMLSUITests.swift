//  UMLSUITests.swift

import XCTest
import UMLSClient

extension String {

    static func randomConceptString() -> String {
        "C\(Int.random(in: 1000000...9999999))"
    }

}

final class UMLSUITests: XCTestCase {

    func testInitializeWithValidString() throws {
        let conceptString = String.randomConceptString()
        let ui = try UMLSUI<UMLSConcept>(string: conceptString)
        XCTAssertEqual(ui.description, conceptString)
    }

    func testInitializeInvalidFormat() throws {
        [
            "C12345678",
            "C123456",
            "C123silc",
            "C192",
            "Z1234567",
            "12345C67",
            "1234567C",
            "1234_3689"
        ].forEach { str in
            do {
                _ = try UMLSUI<UMLSConcept>(string: str)
                XCTFail("Unable to raise UMLSUIStringError error")
            } catch let error as UMLSUIStringError {
                switch error {
                case .invalidFormat:
                    XCTAssert(true)
                default:
                    XCTFail("Unexpected UMLSUIStringError: \(error)")
                }
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

}
