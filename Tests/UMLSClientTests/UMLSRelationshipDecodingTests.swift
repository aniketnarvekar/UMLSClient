//  UMLSRelationshipDecodingTests.swift

import XCTest
import UMLSClient

extension DecodingError.Context {

    func assertContext(
        codingPath name: String,
        debugDescription: String? = nil
    ) {
        XCTAssertEqual(codingPath[0].stringValue, name)
        if let description = debugDescription {
            XCTAssertEqual(description, self.debugDescription)
        }
    }

}

final class UMLSRelationshipDecodingTests: XCTestCase {

    var decoder: JSONDecoderAssertion<UMLSRelationship>!

    override func setUp() {
        self.decoder = .init()
    }

    func getUMLSRelationJSON(
        ui: String = "R\(Int.random(in: 100000000...999999999))",
        isSuppressible: Bool = .random(),
        sourceUI: String = String.randomAlphaNumericString(of: 20),
        isObsolete: Bool = .random(),
        isSourceOriginated: Bool = .random(),
        sourceVocabulary: UMLSSourceVocabulary = .random(),
        groupID: String = String.randomAlphaNumericString(of: 1),
        attributeCount: Int = .random(in: 0...Int.max),
        relatedFromIdName: String = String.randomAlphaNumericString(of: 30),
        relationLabel: UMLSRelationLabel = .random(),
        additionalRelationLabel: UMLSAdditionalRelationLabel = .random(),
        relatedIdName: String = String.randomAlphaNumericString(of: 10)
        ) -> Data {
        """
{
    "ui": "\(ui)",
    "suppressible": \(isSuppressible),
    "sourceUi": "\(sourceUI)",
    "obsolete": \(isObsolete),
    "sourceOriginated": \(isSourceOriginated),
    "rootSource": "\(sourceVocabulary.rawValue)",
    "groupId": "\(groupID)",
    "attributeCount": \(attributeCount),
    "relatedFromIdName": "\(relatedFromIdName)",
    "relationLabel": "\(relationLabel.rawValue)",
    "additionalRelationLabel": "\(additionalRelationLabel.rawValue)",
    "relatedIdName": "\(relatedIdName)"
}
""".data(using: .utf8)!
    }

    func testWithValidJSON() throws {
        let ui = "R188723761"
        let sourceUI = String.randomNumericString(of: 10)
        let source = UMLSSourceVocabulary.random()
        let groupID = "1"
        let attributeCount = 0
        let relatedFromIdName = "Benign recurrent vertigo"
        let relatedToIdName = "Benign paroxysmal vertigo, unspecified ear"
        let relationLabel = UMLSRelationLabel.ro
        let additionalRelationLabel = UMLSAdditionalRelationLabel.mappedTo
        let jsonData = getUMLSRelationJSON(
            ui: ui,
            isSuppressible: false,
            sourceUI: sourceUI,
            isObsolete: false,
            isSourceOriginated: false,
            sourceVocabulary: source,
            groupID: groupID,
            attributeCount: attributeCount,
            relatedFromIdName: relatedFromIdName,
            relationLabel: relationLabel,
            additionalRelationLabel: additionalRelationLabel,
            relatedIdName: relatedToIdName
        )
        let relationship = try decoder.decode(
            from: jsonData
        )
        XCTAssertEqual(relationship.ui.description, ui)
        XCTAssertEqual(relationship.sourceUI, sourceUI)
        XCTAssertFalse(relationship.isSuppressible)
        XCTAssertFalse(relationship.isObsolete)
        XCTAssertFalse(relationship.isSourceOriented)
        XCTAssertEqual(relationship.sourceVocabulary, source)
        XCTAssertEqual(relationship.groupID, groupID)
        XCTAssertEqual(relationship.attributeCount, attributeCount)
        XCTAssertEqual(relationship.relatedFromIdName, relatedFromIdName)
        XCTAssertEqual(relationship.relatedIdName, relatedToIdName)
        XCTAssertEqual(relationship.relationLabel, relationLabel)
        XCTAssertEqual(relationship.additionalRelationLabel, additionalRelationLabel)
    }

    func testInvalidUI() throws {
        let jsonData: [Data] = [
            "\(Int.random(in: 1000000000...9999999999))",
            "C\(Int.random(in: 100000000...999999999))",
            "\(String.randomAlphaNumericString(of: 10))",
            "",
            "😁"
        ]
            .map({ getUMLSRelationJSON(ui: $0)})

        jsonData.forEach { jsonData in
            decoder.assertCorrupted(from: jsonData, for: "ui")
        }
    }

    func testEmptySourceUI() throws {
        let jsonData = getUMLSRelationJSON(sourceUI: "")
        decoder.assertCorrupted(from: jsonData, for: "sourceUi")
    }

    func testNoSourceUI() throws {
        let jsonData = getUMLSRelationJSON(sourceUI: .NONE)
        let object = try decoder.decode(from: jsonData)
        XCTAssertNil(object.sourceUI)
    }

    func testEmptyGroupID() throws {
        let jsonData = getUMLSRelationJSON(groupID: "")
        decoder.assertCorrupted(from: jsonData, for: "groupId")
    }

    func testNoGroupID() throws {
        let jsonData = getUMLSRelationJSON(groupID: .NONE)
        let result = try decoder.decode(from: jsonData)
        XCTAssertNil(result.groupID)
    }

    func testNegativeAttributeCount() throws {
        let jsonData = getUMLSRelationJSON(attributeCount: .random(in: Int.min..<0))
        decoder.assertCorrupted(from: jsonData, for: "attributeCount")
    }

    func testEmptyRelatedFromIDName() throws {
        let jsonData = getUMLSRelationJSON(relatedFromIdName: "")
        decoder.assertCorrupted(from: jsonData, for: "relatedFromIdName")
    }

    func testEmptyRelatedIdName() throws {
        let jsonData = getUMLSRelationJSON(relatedIdName: "")
        decoder.assertCorrupted(from: jsonData, for: "relatedIdName")
    }

}
