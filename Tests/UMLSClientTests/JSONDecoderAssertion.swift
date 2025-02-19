//  JSONDecoderAssertion.swift

import Foundation
import XCTest

struct JSONDecoderAssertion<T: Decodable> {

  private let decoder: JSONDecoder

  init(decoder: JSONDecoder) {
    self.decoder = decoder
  }

  init() {
    self.init(decoder: .init())
  }

  func decode(from data: Data) throws -> T {
    try decoder.decode(T.self, from: data)
  }

  func decodeWithError(
    from data: Data,
    completion: (DecodingError) -> Void
  ) {
    do {
      _ = try decode(from: data)
      XCTFail("Unable to raise DecodingError.")
    } catch let error as DecodingError {
      completion(error)
    } catch {
      XCTFail("Unexpected Error: \(error)")
    }
  }

  func decodeCorrupted(
    from data: Data,
    completion: (DecodingError.Context) -> Void
  ) {
    decodeWithError(from: data) { error in
      switch error {
      case .dataCorrupted(let context):
        completion(context)
      default:
        XCTFail("Unexpected decoding error: \(error)")
      }
    }
  }

  func assertCorrupted(
    from data: Data,
    for key: String,
    debugDescription: String? = nil
  ) {
    decodeCorrupted(from: data) { context in
      XCTAssertEqual(context.codingPath[0].stringValue, key)
      if let description = debugDescription {
        XCTAssertEqual(context.debugDescription, description)
      }
    }
  }

}
