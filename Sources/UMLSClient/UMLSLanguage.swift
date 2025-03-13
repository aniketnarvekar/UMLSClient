// UMLSLanguage.swift

import Foundation

#if SourceVocabulary

  // MARK: - Object type enumeration

  public enum UMLSObject: String, Codable {
    case language = "Language"
    case contentInfo = "ContactInformation"
  }

  // MARK: - Object Type Specification

  public protocol UMLSTypeCodable: Codable {
    associatedtype Object: Codable
    var object: Object { get }
  }

  // MARK: - Language

  // MARK: Specification

  /// The UMLS Language specification.
  public protocol UMLSLanguage {
    /// An language abbreviation.
    var abbreviation: UMLSLanguageAbbreviation { get }
    /// A human readable name of the language.
    var name: UMLSLanguageName { get }
  }

  // MARK: Implementation

  public struct UMLSLanguageInfo: UMLSLanguage {

    public var abbreviation: UMLSLanguageAbbreviation
    public var name: UMLSLanguageName

    public init(
      abbreviation: UMLSLanguageAbbreviation, name: UMLSLanguageName
    ) {
      self.abbreviation = abbreviation
      self.name = name
    }

  }

  extension UMLSLanguageInfo: Codable {

    private enum CodingKeys: String, CodingKey {
      case abbreviation
      case name = "expandedForm"
    }

  }

  // MARK: - Language Object Type

  // MARK: Specification

  public protocol UMLSLanguageType: UMLSTypeCodable
  where Self.Object: UMLSLanguage {}

  // MARK: Implementation

  public struct UMLSLanguageTypeObject<U: UMLSLanguage & Codable>: UMLSLanguageType,
    Codable
  {

    public var object: U

    private enum CodingKeys: CodingKey {
      case classType
    }

    public init(object: U) {
      self.object = object
    }

    public init(from decoder: any Decoder) throws {

      let container = try decoder.container(keyedBy: CodingKeys.self)
      let type = try container.decode(UMLSObject.self, forKey: .classType)
      guard type == .language else {
        throw
          DecodingError
          .dataCorruptedError(
            forKey: .classType, in: container,
            debugDescription: "Unsupported class type \(type.rawValue)")
      }

      let singleValueContainer = try decoder.singleValueContainer()
      self.object = try singleValueContainer.decode(U.self)
    }

    public func encode(to encoder: any Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(UMLSObject.language, forKey: .classType)
      try self.object.encode(to: encoder)
    }
  }

  // MARK: - Address

  // MARK: Implementation

  /// A protocol that defines the essential components of a postal address.
  public protocol UMLSAddress {
    /// The primary address line, typically including the street name and number.
    var address1: String? { get }

    /// An optional secondary address line, such as an apartment or suite number.
    var address2: String? { get }

    /// The city or locality of the address.
    var city: String? { get }

    /// The state or province of the address.
    var stateOrProvince: String? { get }

    /// The country of the address.
    var country: String? { get }

    /// The postal or ZIP code of the address.
    var zipCode: String? { get }
  }

  // MARK: Implementation

  public struct UMLSPostalAddress: UMLSAddress, Decodable {
    public var address1: String?
    public var address2: String?
    public var city: String?
    public var stateOrProvince: String?
    public var country: String?
    public var zipCode: String?

    private enum CodingKeys: CodingKey {
      case address1
      case address2
      case city
      case stateOrProvince
      case country
      case zipCode
    }

    private static func stringOrNil(
      from container: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys
    ) throws -> String? {
      let string = try container.decode(String.self, forKey: key).trimmingCharacters(
        in: .whitespacesAndNewlines)
      return ![.none, ""].contains(string) ? string : nil
    }

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)

      self.address1 = try UMLSPostalAddress.stringOrNil(from: container, forKey: .address1)
      self.address2 = try UMLSPostalAddress.stringOrNil(from: container, forKey: .address2)
      self.city = try UMLSPostalAddress.stringOrNil(from: container, forKey: .city)
      self.stateOrProvince = try UMLSPostalAddress.stringOrNil(
        from: container, forKey: .stateOrProvince)
      self.country = try UMLSPostalAddress.stringOrNil(from: container, forKey: .country)
      self.zipCode = try UMLSPostalAddress.stringOrNil(from: container, forKey: .zipCode)

    }

  }

#endif
