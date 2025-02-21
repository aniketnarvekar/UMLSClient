// UMLSClient.swift

import Foundation

public enum UMLSError: Error {
  case sessionError(error: Error)
  case decodingError(error: Error)
  case unknown
  case notFound
  case unauthorized
  case client(message: String)
}

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
  public init(
    apiKey: String, baseURL: URL, version: UMLSVersion, session: URLSession = .shared,
    decoder: JSONDecoder = .init()
  ) {
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
      .init(
        name: "includeSuppressible", value: searchParameters.includeSuppressible ? "true" : "false"),
      .init(name: "returnIdType", value: searchParameters.returnIdType.rawValue),
      .init(
        name: "sabs",
        value: searchParameters.sourceVocabularies
          .map({ $0.rawValue })
          .joined(separator: ",")
      ),
      .init(name: "searchType", value: searchParameters.searchType.rawValue),
      .init(name: "partialSearch", value: searchParameters.partialSearch ? "true" : "false"),
      .init(name: "pageNumber", value: searchParameters.pageNumber.description),
      .init(name: "pageSize", value: searchParameters.pageSize.description),
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

class __UMLSConceptController: UMLSRestAPIClient {

  let apiKey: String
  let baseURL: URL
  let version: UMLSVersion
  var session: URLSession
  var decoder: JSONDecoder

  public init(
    apiKey: String, baseURL: URL, version: UMLSVersion, session: URLSession = .shared,
    decoder: JSONDecoder = .init()
  ) {
    self.apiKey = apiKey
    self.baseURL = baseURL
    self.version = version
    self.session = session
    self.decoder = decoder
  }

}

extension __UMLSConceptController: UMLSConceptController {

  struct DecoderError: Decodable {
    let message: String
  }

  func preferred(_ concept: UMLSUI<UMLSConcept>) async throws -> UMLSPage<UMLSAtomInfo> {
    return try await get(
      UMLSPage<UMLSAtomInfo>.self, concept: .preferred(for: concept, version: version))
  }

  func info(of ui: UMLSUI<UMLSConcept>) async throws -> UMLSPage<UMLSConceptInfo> {
    return try await get(
      UMLSPage<UMLSConceptInfo>.self, concept: .conceptInfo(for: ui, version: version))
  }

  func atoms(using parameters: any UMLSConceptAtomParameters) async throws -> UMLSPage<
    [UMLSAtomInfo]
  > {
    return try await get(
      UMLSPage<[UMLSAtomInfo]>.self, concept: .atoms(using: parameters, version: version))
  }

  func definitions(using parameters: any UMLSConceptDefinitionParameters) async throws -> UMLSPage<
    [UMLSDefinition]
  > {
    return try await get(
      UMLSPage<[UMLSDefinition]>.self, concept: .definitions(using: parameters, version: version))
  }

  func relations(using parameters: any UMLSConceptRelationParameters) async throws -> UMLSPage<
    [UMLSRelationship]
  > {
    return try await get(
      UMLSPage<[UMLSRelationship]>.self, concept: .relations(using: parameters, version: version))
  }

}

protocol UMLSRestAPIClient {
  var baseURL: URL { get }
  var apiKey: String { get }
  var session: URLSession { get }
  var decoder: JSONDecoder { get }
}

struct DecoderError: Decodable {
  let message: String
}

extension UMLSRestAPIClient {

  func get<T: Decodable>(_ type: T.Type, concept uri: UMLSConceptURI) async throws -> T {

    var url: URL
    if #available(iOS 16.0, *) {
      url = baseURL.appending(queryItems: [.init(name: "apiKey", value: apiKey)])
    } else {
      var component = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
      component.queryItems?.append(.init(name: "apiKey", value: apiKey))
      url = component.url!
    }
    url = uri.url(for: url)

    let set: (Data, URLResponse)
    do {
      set = try await session.data(for: URLRequest(url: url))
    } catch let error {
      throw UMLSError.sessionError(error: error)
    }
    let response = set.1 as! HTTPURLResponse
    let data = set.0
    switch response.statusCode {
    case 200:
      do {
        return try decoder.decode(T.self, from: data)
      } catch let error {
        throw UMLSError.decodingError(error: error)
      }
    case 404:
      throw UMLSError.notFound
    case 401:
      throw UMLSError.unauthorized
    case 400:
      let error = try decoder.decode(DecoderError.self, from: data)
      throw UMLSError.client(message: error.message)
    default:
      throw UMLSError.unknown
    }
  }
}

#if SemanticType

  private class __UMLSSemanticTypeController: UMLSRestAPIClient {

    let apiKey: String
    let baseURL: URL
    let version: UMLSVersion
    var session: URLSession
    var decoder: JSONDecoder

    public init(
      apiKey: String,
      baseURL: URL,
      version: UMLSVersion,
      session: URLSession = .shared,
      decoder: JSONDecoder = .init()
    ) {
      self.apiKey = apiKey
      self.baseURL = baseURL
      self.version = version
      self.session = session
      self.decoder = decoder
    }

  }

  extension __UMLSSemanticTypeController: UMLSSemanticTypeController {

    func info(of ui: UMLSUI<UMLSTUI>) async throws -> UMLSPage<UMLSSemanticTypeInfo> {
      try await get(
        UMLSPage<UMLSSemanticTypeInfo>.self,
        concept: .semanticType(for: ui, version: version)
      )
    }

  }

#endif

/// UMLS client to query UMLS REST API server.
public class UMLSClient {

  private let baseURL: URL
  private let apiKey: String
  private let version: UMLSVersion
  private let session: URLSession
  private let decoder: JSONDecoder

  private lazy var searchCon: UMLSSearchController = { [unowned self] in
    __UMLSSearchController(
      apiKey: self.apiKey,
      baseURL: self.baseURL,
      version: version,
      session: session,
      decoder: decoder
    )
  }()

  private lazy var conceptCon: UMLSConceptController = { [unowned self] in
    __UMLSConceptController(
      apiKey: self.apiKey,
      baseURL: self.baseURL,
      version: self.version,
      session: self.session,
      decoder: self.decoder
    )
  }()

  #if SemanticType

    private lazy var semanticTypeCon: UMLSSemanticTypeController = { [unowned self] in
      __UMLSSemanticTypeController(
        apiKey: apiKey, baseURL: baseURL, version: version, session: session, decoder: decoder)
    }()

  #endif

  /// Create new client object
  /// - Parameters:
  ///   - baseURL: The base URL that will be used to send a request to. See [documentation](https://documentation.uts.nlm.nih.gov/rest/home.html)
  ///   - apiKey: The API key for UTS profile. Click [here](https://documentation.uts.nlm.nih.gov/rest/authentication.html) for more information.
  ///   - version: The UMLS version where you want data from.
  ///   - session: The session object
  ///   - decoder: The decoder to decoder response body.
  public init(
    baseURL: URL, apiKey: String, version: UMLSVersion, session: URLSession = .shared,
    decoder: JSONDecoder = .init()
  ) {
    self.baseURL = baseURL
    self.apiKey = apiKey
    self.version = version
    self.session = session
    self.decoder = decoder
  }

  /// The search controller object.
  public func searchController() -> UMLSSearchController {
    searchCon
  }

  /// The concept controller object.
  public func conceptController() -> UMLSConceptController {
    conceptCon
  }

  #if SemanticType

    public func semanticTypeController() -> UMLSSemanticTypeController {
      semanticTypeCon
    }

  #endif

}
