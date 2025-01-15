// UMLSSearchParameters.swift
// Create UMLS search parameters.

import Foundation

/// The search input types.
///
/// Use `sourceUI` if you aren’t sure if the identifier you’re providing is a code, source concept, or source descriptor.
///
/// Using `tty` is for advanced use cases and will extract codes from a specified vocabulary according to [term type](https://www.nlm.nih.gov/research/umls/knowledge_sources/metathesaurus/release/precedence_suppressibility.html?_gl=1*18rbq7j*_ga*MTI2NDM5OTAzMS4xNzI4OTc4NTAy*_ga_7147EPK006*MTczNjUwNTM1Ni4zOS4xLjE3MzY1MDY0MDUuMC4wLjA.*_ga_P1FPTH9PL4*MTczNjUwNTM1Ni4zOS4xLjE3MzY1MDY0MDUuMC4wLjA.).
public enum UMLSSearchInputType: String {
    case atom = "atom"
    case code = "code"
    case sourceConcept = "sourceConept"
    case sourceDescriptor = "sourceDescriptor"
    case sourceUI = "sourceUi"
    case tty = "tty"
}

/// The search result identifier type.
///
/// Use `code`,`sourceConcept`, `sourceDescriptor`, or `sourceUi` if you prefer source-asserted identifiers rather than CUIs in your search results.
public enum UMLSSearchReturnIDType: String {
    case aui = "aui"
    case concept = "concept"
    case code = "code"
    case sourceConcept = "sourceConcept"
    case sourceDescriptor = "sourceDescriptor"
    case sourceUI = "sourceUi"
}

/// The type of search.
public enum UMLSSearchType: String {
    /// Retrieves only concepts that include a synonym that exactly matches the search term.
    case exact = "exact"
    /// Retrieves results where all words in the query appear in a particular name.
    case words = "words"
    /// Retrieves concepts with synonyms that end with the letters of the search term. For example, a left truncation search for “itis” retrieves concepts that contain synonyms such as colitis, bronchitis, pancreatitis.
    case leftTruncation = "leftTruncation"
    /// Retrieves concepts with synonyms that begin with the letters of the search term. For example, a right truncation search for “bronch” retrieves concepts that contain synonyms such as bronchitis, bronchiole, bronchial artery.
    case rightTruncation = "rightTruncation"
    /// Removes lexical variations such as plural and upper case text and compares search terms to the Metathesaurus normalized string index to retrieve relevant concepts.
    case normalizedString = "normalizedString"
    /// Removes lexical variations such as plural and upper case text, and compares search terms to the Metathesaurus normalized word index to retrieve relevant concepts.
    case normalizedWords = "normalizedWords"
}

/// The search parameters for UMLS Search API.
///
/// The protocol defines possible search parameters.
public protocol UMLSSearchParameters {
    /// The search string.
    var string: String { get }
    /// The search input type.
    var inputType: UMLSSearchInputType { get }
    /// Whether to include Obsolete terms or not.
    var includeObsolete: Bool { get }
    /// Whether to include suppressible terms or not.
    var includeSuppressible: Bool { get }
    /// The return identiifer type.
    var returnIdType: UMLSSearchReturnIDType { get }
    /// The list of UMLS source vocabularies.
    var sourceVocabularies: [String] { get }
    /// The search type.
    var searchType: UMLSSearchType { get }
    /// Whether th search is partical or not.
    var partialSearch: Bool { get }
    /// The page number.
    var pageNumber: Int { get }
    /// The page size for given `pageNumber`
    var pageSize: Int { get }
}

private struct __UMLSSearchParameters: UMLSSearchParameters {
    var string: String
    var inputType: UMLSSearchInputType
    var includeObsolete: Bool
    var includeSuppressible: Bool
    var returnIdType: UMLSSearchReturnIDType
    var sourceVocabularies: [String]
    var searchType: UMLSSearchType
    var partialSearch: Bool
    var pageNumber: Int
    var pageSize: Int

    fileprivate init(
        string: String,
        inputType: UMLSSearchInputType,
        includeObsolete: Bool,
        includeSuppressible: Bool,
        returnIdType: UMLSSearchReturnIDType,
        sourceVocabularies: [String],
        searchType: UMLSSearchType,
        partialSearch: Bool,
        pageNumber: Int,
        pageSize: Int
    ) {
        self.string = string
        self.inputType = inputType
        self.includeObsolete = includeObsolete
        self.includeSuppressible = includeSuppressible
        self.returnIdType = returnIdType
        self.sourceVocabularies = sourceVocabularies
        self.searchType = searchType
        self.partialSearch = partialSearch
        self.pageNumber = pageNumber
        self.pageSize = pageSize
    }

}

/// The `UMLSSearchParameters` builder.
public class UMLSSearchParametersBuilder {

    private var string: String
    private var inputType: UMLSSearchInputType?
    private var includeAbsolute: Bool?
    private var includeSuppressible: Bool?
    private var returnIdType: UMLSSearchReturnIDType?
    private var sourceVocabularies: [String] = []
    private var searchType: UMLSSearchType?
    private var partialSearch: Bool?
    private var pageNumber: Int?
    private var pageSize: Int?

    /// The search parameter build error.
    public enum BuildError: Error, Equatable {
        case emptySearchString
        case invalidPageSize(number: Int)
        case invalidPageNumber(number: Int)
        case emptySourceVocabularyName
    }

    /// Initialize `UMLSSearchParametersBuilder` object.
    ///
    /// - Parameter string: A search string.
    /// - Throws: Raise `BuildErorr.emptySearchString` if the string is empty.
    public init(_ string: String) throws {
        guard !string.isEmpty else {
            throw BuildError.emptySearchString
        }
        self.string = string
    }

    /// Sets a new search string.
    /// - Parameter string: a search string
    /// - Returns: Returns reference to `Self`.
    /// - Throws: Raise `BuildErorr.emptySearchString` if the string is empty.
    public func setSearchText(_ string: String) throws -> Self {
        guard !string.isEmpty else {
            throw BuildError.emptySearchString
        }
        self.string = string
        return self
    }

    /// Sets input type.
    /// - Parameter inputType: search input type.
    /// - Returns: Returns reference to `Self`.
    public func setInputType(_ inputType: UMLSSearchInputType) -> Self {
        self.inputType = inputType
        return self
    }

    /// Set whether search include obsolete or not.
    /// - Parameter bool: `true` for include obsolete else `false`.
    /// - Returns: Returns reference to `Self`.
    public func setIncludeObsolete(_ bool: Bool) -> Self {
        self.includeAbsolute = bool
        return self
    }

    /// Set whether search include suppressible terms.
    /// - Parameter bool: `true` for include suppressible else `false`.
    /// - Returns: Returns reference to `Self`.
    public func setIncludeSuppressible(_ bool: Bool) -> Self {
        self.includeSuppressible = bool
        return self
    }

    /// Add source vocabulary.
    ///
    ///If source vocabulary already present then skip.
    ///
    /// The string should be UMLS asserted [source vocabulary](https://www.nlm.nih.gov/research/umls/sourcereleasedocs/) abbreviation.
    /// - Parameter string:
    /// - Returns: Returns reference to `Self`.
    public func addSourceVocabulary(_ string: String) throws -> Self {
        // TODO: User source vocabulary as swift object for compile time validation of the source vocabulary.
        guard !string.isEmpty else {
            throw BuildError.emptySourceVocabularyName
        }
        if !self.sourceVocabularies.contains(string) {
            self.sourceVocabularies.append(string)
        }
        return self
    }

    /// Remove source vocabulary if present.
    /// - Parameter string: A source vocabulary.
    /// - Returns: Returns reference to `Self`.
    public func removeSourceVocabulary(_ string: String) -> Self {
        if let index = self.sourceVocabularies.firstIndex(of: string) {
            self.sourceVocabularies.remove(at: index)
        }
        return self
    }

    /// Set search type.
    /// - Parameter searchType: Search type.
    /// - Returns: Returns reference to `Self`.
    public func setSearchType(_ searchType: UMLSSearchType) -> Self {
        self.searchType = searchType
        return self
    }

    /// Set whether search is partial search.
    /// - Parameter bool: `true` if partial else `false`.
    /// - Returns: Returns reference to `Self`.
    public func setPartialSearch(_ bool: Bool) -> Self {
        self.partialSearch = bool
        return self
    }

    /// Set page size.
    ///
    /// The page size should be > 0.
    /// - Parameter number: The page number.
    /// - Returns: Returns reference to `Self`.
    /// - Throws: Raise `BuildErorr.invalidPageSize(number:)` if number <= 0.
    public func setPageSize(_ number: Int) throws -> Self {
        guard number > 0 else {
            throw BuildError.invalidPageSize(number: number)
        }
        self.pageSize = number
        return self
    }

    /// Set page number.
    ///
    /// The page number should be > 0.
    /// - Parameter number: The page size.
    /// - Returns:Returns reference to `Self`.
    /// - Throws: Raise `BuildErorr.invalidPageNumber(number:)` if number <= 0.
    public func setPageNumber(_ number: Int) throws -> Self {
        guard number > 0 else {
            throw BuildError.invalidPageNumber(number: number)
        }
        self.pageNumber = number
        return self
    }

    /// Create and return object that implements `UMLSSearchParameters`.
    ///
    /// The function sets the following default parameters if not specified:
    /// - intputType: `UMLSSearchType.Atom`
    /// - includeObsolete: `false`
    /// - includeSuppressible: `false`
    /// - returnIdType: `UMLSSearchReturnIDType.Concept`
    /// - sourceVocabularies: `[]`
    /// - searchType: `UMLSSearchType.Words`
    /// - partialSearch: `false`
    /// - pageNumber: `1`
    /// - pageSize: `25`
    /// - Returns: Returns object that implements ``UMLSSearchParameters``.
    public func build() -> UMLSSearchParameters {
        __UMLSSearchParameters(
            string: self.string,
            inputType: self.inputType ?? .atom,
            includeObsolete: includeAbsolute ?? false,
            includeSuppressible: includeSuppressible ?? false,
            returnIdType: returnIdType ?? .concept,
            sourceVocabularies: self.sourceVocabularies,
            searchType: self.searchType ?? .words,
            partialSearch: self.partialSearch ?? false,
            pageNumber: self.pageNumber ?? 1,
            pageSize: self.pageSize ?? 25)
    }

}
