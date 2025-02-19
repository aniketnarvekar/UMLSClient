//  UMLSClient.swift

import XCTest

@testable import UMLSClient

extension UMLSClient {

  static func getTestAPIKey() -> String {
    ProcessInfo.processInfo.environment["UMLS_API_KEY"]!
  }

  static func getTestVersion() -> UMLSVersion {
    let versionString = ProcessInfo.processInfo.environment["UMLS_VERSION"]!
    return try! .init(string: versionString)
  }

  static func getTestBaseURL() -> URL {
    let baseURLStirng = ProcessInfo.processInfo.environment["UMLS_HOST"]!
    return URL(string: baseURLStirng)!
  }

  static func getTestContentSize() -> UInt {
    let contentSizeString = ProcessInfo.processInfo.environment["UMLS_PAGE_CONTENT_SIZE"]!
    return .init(contentSizeString)!
  }

  static func getJSONDecoder() -> JSONDecoder {
    let jsonDecoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy"
    jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    return jsonDecoder
  }

  static func initializeTestClient(
    baseURL: URL = getTestBaseURL(),
    apiKey: String = getTestAPIKey(),
    version: UMLSVersion = getTestVersion(),
    decoder: JSONDecoder = getJSONDecoder()
  ) -> UMLSClient {
    UMLSClient(baseURL: baseURL, apiKey: apiKey, version: version, decoder: decoder)
  }

}
