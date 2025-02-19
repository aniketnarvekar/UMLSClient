import Foundation

extension KeyedDecodingContainerProtocol {

  /// Decode bool `string` value to `Bool`.
  ///
  /// The value of the key should be "true" or "false" (case sensitive) else raise `DecodingError.dataCorruptedError```
  /// - Parameter key: The key that the decoded value is associated with.
  /// - Returns: The boolean value of string representation.
  /// - Throws: `DecodingError.dataCorruptedError` if value string is convertable to Bool.
  /// - Throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
  /// - Throws: `DecodingError.keyNotFound` if self does not have an entry for the given key.
  /// - Throws: `DecodingError.valueNotFound` if self has a null entry for the given key.
  public func decodeStringBool(forKey key: Self.Key) throws -> Bool {
    let string = try self.decode(String.self, forKey: key)
    return switch string {
    case "true": true
    case "false": false
    default:
      throw DecodingError.dataCorruptedError(
        forKey: key,
        in: self,
        debugDescription: "Invalid value expected \"true\" or \"false\" but found: \(string)."
      )
    }
  }

  /// Decodes `String` value for given key.
  /// - Parameter key: The key that the decoded value is associated with.
  /// - Returns: The non-empty `String`.
  /// - Throws: `DecodingError.dataCorruptedError` If value is empty `string`.
  /// - Throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
  /// - Throws: `DecodingError.keyNotFound` if self does not have an entry for the given key.
  /// - Throws: `DecodingError.valueNotFound` if self has a null entry for the given key.
  public func decodeNonEmptyString(forKey key: Self.Key) throws -> String {
    let string = try self.decode(String.self, forKey: key)
    guard !string.isEmpty else {
      throw DecodingError.dataCorruptedError(
        forKey: key,
        in: self,
        debugDescription: "Empty value."
      )
    }
    return string
  }

  /// Decodes `String` value for given key.
  ///
  /// If string is "NONE" returns nil else return string.
  /// - Parameter key: The key that the decoded value is associated with.
  /// - Returns: The non-empty `String`.
  /// - Throws: `DecodingError.dataCorruptedError` If value is empty `string`.
  /// - Throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
  /// - Throws: `DecodingError.keyNotFound` if self does not have an entry for the given key.
  /// - Throws: `DecodingError.valueNotFound` if self has a null entry for the given key.
  public func decodeNoneString(forKey key: Self.Key) throws -> String? {
    let string = try self.decodeNonEmptyString(forKey: key)
    return string == .NONE ? nil : string
  }

  /// Decodes `Int` value for given key.
  /// - Parameter key: The key that the decoded value is associated with.
  /// - Returns: The natural number.
  /// - Throws: `DecodingError.dataCorruptedError` If value is not a natural number.
  /// - Throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
  /// - Throws: `DecodingError.keyNotFound` if self does not have an entry for the given key.
  /// - Throws: `DecodingError.valueNotFound` if self has a null entry for the given key.
  public func decodeNaturalNumber(forKey key: Self.Key) throws -> Int {
    let result = try decode(Int.self, forKey: key)
    guard result.isNaturalNumber else {
      throw DecodingError.dataCorruptedError(
        forKey: key,
        in: self,
        debugDescription: "The number \(result) is not a natural number."
      )
    }
    return result
  }

}
