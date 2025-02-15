//  UMLSDefinitionDecodingTests.swift

import XCTest
import UMLSClient

final class UMLSDefinitionDecodingTests: XCTestCase {

    var decoder: JSONDecoderAssertion<UMLSDefinition>!

    override func setUp() {
        decoder = .init()
    }

    func definitionJSON(
      source: UMLSSourceVocabulary = .random(),
      definition: String = String.randomAlphaNumericString(of: 100)
    ) -> Data {
        """
{
    "rootSource": "\(source.rawValue)",
    "value": "\(definition)"
}
""".data(using: .utf8)!
    }

    func testWithValidJSON() throws {
        let source = UMLSSourceVocabulary.alt
        let value = "Idiopatické rekurentní vertigo spojené s polohovým nystagmem. Je způsobené poruchou vestibulárního aparátu. Na rozdíl od labyrintitidy a vestibulární neuronitidy se neprojevuje zánětem ucha."
        let jsonData = definitionJSON(source: source, definition: value)
        let result = try decoder.decode(from: jsonData)
        XCTAssertEqual(result.definition, value)
    }

    func testEmptyDefinition() throws {
        let jsonData = definitionJSON(definition: "")
        decoder.assertCorrupted(from: jsonData, for: "value")
    }

}
