//  ConceptAtomsTests.swift

import XCTest
@testable import UMLSClient


final class ConceptAtomsTests: XCTestCase, UMLSTestUtility {

    var client: UMLSClient!

    override func setUpWithError() throws {
        self.client = .initializeTestClient()
    }

    override func tearDownWithError() throws {
        self.client = nil
    }

    func testWithDefaultRequest() async throws {
        let params = UMLSConceptAtomParametersBuilder(concept: .random())
            .build()
        let page = try await client.conceptController().atoms(using: params)
        XCTAssertEqual(page.size, 25)
        XCTAssertEqual(page.number, 1)
        XCTAssertEqual(page.count, page.getTestPageCount())
        XCTAssertTrue(!page.element.isEmpty)
        XCTAssertEqual(page.element.count, 25)

        let element = page.element
        XCTAssertTrue(element.every(completion: { !$0.name.isEmpty }))
        XCTAssertTrue(element.every(completion: { !$0.isObsolete }))
        XCTAssertTrue(element.every(completion: { !$0.isSuppressible }))

    }

    func testWithInvalidAPIKey() async throws {
        self.client = .initializeTestClient(apiKey: .randomAlphaNumericString(of: 30))
        try await self.unautorizedError { client in
            let params = UMLSConceptAtomParametersBuilder(concept: .random()).build()
            return try await client.conceptController().atoms(using: params)
        }
    }

    func testWithZeroPageSize() async throws {
        let params = UMLSConceptAtomParametersBuilder(concept: .random())
            .setPageInfo(.init(size: 0))
            .build()
        let result = try await client.conceptController().atoms(using: params)
        XCTAssertEqual(result.size, 25)
        XCTAssertLessThanOrEqual(result.element.count, 25)
    }

    func testWithZeroPageNumber() async throws {
        let params = UMLSConceptAtomParametersBuilder(concept: .random())
            .setPageInfo(.init(number: 0))
            .build()
        let result = try await client.conceptController().atoms(using: params)
        XCTAssertEqual(result.number, 1)
    }

    func testWithPageSizeGreaterThan10000() async throws {
        try await clientError { client in
            let size = (10001...Int.max).randomElement()!
            let params = UMLSConceptAtomParametersBuilder(concept: .random())
                .setPageInfo(.init(size: .init(size)))
                .build()
            return try await client.conceptController().atoms(using: params)
        }
    }

    func testWithPageSizeGreaterThan5000AndNumberGreaterThan1() async throws {
        try await clientError { client in
            let size = (5001...Int.max).randomElement()!
            let number = (2...Int.max).randomElement()!
            let params = UMLSConceptAtomParametersBuilder(concept: .random())
                .setPageInfo(.init(size: .init(size), number: .init(number)))
                .build()
            return try await client.conceptController().atoms(using: params)
        }
    }

    func testWithPageNumberGreaterThanPageCount() async throws {
        let pageCount = PageInfo().pageCountUsingEnvironment
        let pageNumber = pageCount + 1
        let params = UMLSConceptAtomParametersBuilder(concept: .random())
            .setPageInfo(.init(number: pageNumber))
            .build()
        let result = try await client.conceptController().atoms(using: params)
        XCTAssertEqual(result.number, .init(pageNumber))
        XCTAssertGreaterThan(result.number, result.count)
        XCTAssertTrue(result.element.isEmpty)
    }

    func testWithSingleSourceVocabulary() async throws {
        let sourceVocabulary = UMLSSourceVocabulary.random()
        let params = UMLSConceptAtomParametersBuilder(concept: .random())
            .addSourceVocabulary(sourceVocabulary)
            .build()
        let result = try await client.conceptController().atoms(using: params)
        XCTAssertTrue(
            result.element.every(completion: { $0.sourceVocabulary == sourceVocabulary })
        )
    }

    func testWithMultipleSourceVocabularies() async throws {
        let params = UMLSConceptAtomParametersBuilder(concept: .random())
            .setSourceVocabularies([.air, .alt, .aod, .atc, .bi])
            .build()
        let result = try await client.conceptController().atoms(using: params)
        XCTAssertTrue(
            result.element
                .every(completion: { params.sourceVocabularies.contains($0.sourceVocabulary) })
        )
    }

    func testWithSingleTermType() async throws {
        let tty = UMLSTermType.di
        let params = UMLSConceptAtomParametersBuilder(concept: .random())
            .addTermType(tty)
            .build()
        let result = try await client.conceptController().atoms(using: params)
        XCTAssertTrue(
            result.element.every(completion: { $0.termType == tty })
        )
    }

    func testWithMultipleTermType() async throws {
        let params = UMLSConceptAtomParametersBuilder(concept: .random())
            .setTermTypes([.aa, .ab, .ac, .acr, .ad])
            .build()
        let result = try await client.conceptController().atoms(using: params)
        XCTAssertTrue(
            result.element.every(completion: { params.termTypes.contains($0.termType) })
        )
    }

    func testResponseFromSpecificLanguage() async throws {
        let lang = UMLSLanguage.random()
        let params = UMLSConceptAtomParametersBuilder(concept: .random())
            .setLanguage(lang)
            .build()
        let result = try await client.conceptController().atoms(using: params)
        XCTAssertTrue(
            result.element.every(completion: { $0.language == params.language })
        )
    }

    func testIncludeObsolete() async throws {
        let params = UMLSConceptAtomParametersBuilder(concept: .random())
            .setIncludeObsolete(true)
            .build()
        let result = try await client.conceptController().atoms(using: params)
        XCTAssertTrue(
            result.element.some(completion: { $0.isObsolete })
        )
        XCTAssertTrue(
            result.element.some(completion: { !$0.isObsolete })
        )
    }

    func testIncludeSuppressible() async throws {
        let params = UMLSConceptAtomParametersBuilder(concept: .random())
            .setIncludeSuppressible(true)
            .build()
        let result = try await client.conceptController().atoms(using: params)
        XCTAssertTrue(
            result.element.some(completion: { $0.isSuppressible })
        )
        XCTAssertTrue(
            result.element.some(completion: { !$0.isSuppressible })
        )
    }

}

