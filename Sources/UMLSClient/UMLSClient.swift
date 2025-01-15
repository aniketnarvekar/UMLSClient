// UMLSClient.swift

import Foundation

/// A controller to manage UMLS search.
class __UMLSSearchController: UMLSSearchController {

    private let apiKey: String
    private let baseURL: URL
    private let version: UMLSVersion
    private let session: URLSession
    private let decoder: JSONDecoder

    /// Initialize controller with given arguments.
    /// - Parameters:`
    ///   - apiKey: A unique secret key to authenticate the user.
    ///   - host: A UMLS REST API server address.
    ///   - version: The specific UMLS version where the search request is targeted to.
    ///   - session: Used to query server and receive response.
    ///   - decoder: Decode JSON response body.
    public init(apiKey: String, baseURL: URL, version: UMLSVersion, session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.version = version
        self.session = session
        self.decoder = decoder
    }

    // Generate a REST API url using search parameters and global parameters. The only reason the returned ``URL`` is optional because uncertinity of `host` url is
    private func searchURL(from searchParameters: UMLSSearchParameters) -> URL? {
        var component = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        component!.path = component!.path + "/search/\(version.description)"
        component!.queryItems = [
            .init(name: "apiKey", value: self.apiKey),
            .init(name: "string", value: searchParameters.string),
            .init(name: "inputType", value: searchParameters.inputType.rawValue),
            .init(name: "includeObsolete", value: searchParameters.includeObsolete ? "true" : "false"),
            .init(name: "includeSuppressible", value: searchParameters.includeSuppressible ? "true" : "false"),
            .init(name: "returnIdType", value: searchParameters.returnIdType.rawValue),
            .init(name: "sabs", value: searchParameters.sourceVocabularies.joined(separator: ",")),
            .init(name: "searchType", value: searchParameters.searchType.rawValue),
            .init(name: "partialSearch", value: searchParameters.partialSearch ? "true" : "false"),
            .init(name: "pageNumber", value: searchParameters.pageNumber.description),
            .init(name: "pageSize", value: searchParameters.pageSize.description)
        ]
        return component!.url
    }

    /// Sends the request to the UMLS server, processes the response, and returns the page on success.
    ///
    /// The function may raise mutiple errors
    ///  - `NSError` error by `URLSession` on failure.
    /// - `DecodingError` when function is failed to decode the response.
    /// - ``SearchError`` on search failure.
    ///
    /// - Parameters:
    ///   - searchParameters: The parameters used for searching
    ///   - session: A session object used to performing http request.
    /// - Returns: The UMLS  Search page.
    public func search(_ searchParameters: UMLSSearchParameters) async throws -> UMLSSearchPage {
        let url = searchURL(from: searchParameters)!
        let request = URLRequest(url: url)
        let set = try await session.data(for: request)
        let response = set.1 as! HTTPURLResponse
        if response.statusCode == 200 {
            return try decoder.decode(UMLSSearchPage.self, from: set.0)
        } else if response.statusCode == 401 {
            throw SearchError.unauthorized
        } else if (400...499).contains(response.statusCode) {
            throw SearchError.searchError(info: try decoder.decode(SearchErrorInfo.self, from: set.0))
        }
        throw SearchError.unknown
    }

}

public class UMLSClient {

    private let baseURL: URL
    private let apiKey: String
    private let version: UMLSVersion
    private let session: URLSession
    private let decoder: JSONDecoder

    private lazy var __searchController: UMLSSearchController = { [unowned self] in
        __UMLSSearchController(
            apiKey: self.apiKey,
            baseURL: self.baseURL,
            version: version,
            session: session,
            decoder: decoder
        )
    }()

    public init(baseURL: URL, apiKey: String, version: UMLSVersion, session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.version = version
        self.session = session
        self.decoder = decoder
    }

    public func searchController() -> UMLSSearchController {
        __searchController
    }

}

