// UMLSLanguage.swift

import Foundation
import WebURL

#if SourceVocabulary

  // MARK: - Object type enumeration

  public enum UMLSObject: String, Codable {
    case language = "Language"
    case contentInfo = "ContactInformation"
  }

  // MARK: - Object Type Specification

  public protocol UMLSTypeDecodable: Decodable {
    associatedtype Object: Decodable
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

  public protocol UMLSLanguageType: UMLSTypeDecodable
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

  // MARK: Specification

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

  // MARK: - Contact Information

  public protocol UMLSContactInformation {
    associatedtype Address: UMLSAddress
    var handle: String? { get }
    /// A name of the creator.
    var name: String? { get }
    /// A creator's research title.
    var title: String? { get }
    /// A name of the organization.
    var organization: String? { get }
    /// An address 1.
    var address: Address { get }
    /// A telephone number.
    var telephone: String? { get }
    /// A fax number.
    var fax: String? { get }
    /// An email address.
    var email: String? { get }
    /// A website address.
    var url: WebURL? { get }
    /// A string string in which respective values are extracted.
    var value: String { get }

    init(
      handle: String?, name: String?, title: String?, organization: String?,
      address: Address, telephone: String?, fax: String?, email: String?,
      url: WebURL?, value: String
    )
  }

  private enum UMLSContactInformationCodingKeys: CodingKey {
    case handle
    case name
    case title
    case organization
    case telephone
    case fax
    case email
    case url
    case value
  }

  extension UMLSContactInformation where Self.Address: Decodable, Self: Decodable {

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: UMLSContactInformationCodingKeys.self)
      let handle = try container.decodeTrimmedStringOrNil(forKey: .handle)
      let name = try container.decodeTrimmedStringOrNil(forKey: .name)
      let title = try container.decodeTrimmedStringOrNil(forKey: .title)
      let organization = try container.decodeTrimmedStringOrNil(forKey: .organization)
      let telephone = try container.decodeTrimmedStringOrNil(forKey: .telephone)
      let fax = try container.decodeTrimmedStringOrNil(forKey: .fax)
      let email = try container.decodeTrimmedStringOrNil(forKey: .email)
      let urlStringOrNull = try container.decodeTrimmedStringOrNil(forKey: .url)
      var url: WebURL?
      if urlStringOrNull != nil {
        url = try container.decode(WebURL.self, forKey: .url)
      }
      let value = try container.decode(String.self, forKey: .value)
      guard !value.isEmpty else {
        throw DecodingError.dataCorruptedError(
          forKey: .value, in: container, debugDescription: "Empty \"value\" key value.")
      }

      let singleValueContainer = try decoder.singleValueContainer()
      let address = try singleValueContainer.decode(Address.self)

      self.init(
        handle: handle, name: name, title: title, organization: organization, address: address,
        telephone: telephone, fax: fax, email: email, url: url, value: value)

    }

  }

  // MARK: - Creator Contact Information

  // MARK: Specification

  public protocol UMLSCreatorContactInformation: UMLSContactInformation {}

  // MARK: Implementation

  // An object that encapsulates decoded creator contact information.
  public struct UMLSCreatorContact<Address: UMLSAddress & Decodable>: UMLSCreatorContactInformation, Decodable
  {

    public var handle: String?
    public var name: String?
    public var title: String?
    public var organization: String?
    public let address: Address
    public var telephone: String?
    public var fax: String?
    public var email: String?
    public var url: WebURL?
    public var value: String

    public init(
      handle: String? = nil, name: String? = nil, title: String? = nil, organization: String? = nil,
      address: Address, telephone: String? = nil, fax: String? = nil, email: String? = nil,
      url: WebURL? = nil, value: String
    ) {
      self.handle = handle
      self.name = name
      self.title = title
      self.organization = organization
      self.address = address
      self.telephone = telephone
      self.fax = fax
      self.email = email
      self.url = url
      self.value = value
    }

  }

  // MARK: - Contact Information Type Object

  public struct UMLSContactInformationTypeObject<
    T: UMLSContactInformation & Decodable
  >: Decodable
  {
    public let object: T

    private enum CodingKeys: CodingKey {
      case classType
    }

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)

      let classTypeString = try container.decode(String.self, forKey: .classType)
        .trimmingCharacters(in: .whitespacesAndNewlines)
      guard let classType = UMLSObject(rawValue: classTypeString) else {
        throw DecodingError.dataCorruptedError(
          forKey: .classType, in: container, debugDescription: "")
      }
      guard classType == .contentInfo else {
        throw DecodingError.dataCorruptedError(
          forKey: .classType, in: container, debugDescription: "")
      }

      let singleValueContainer = try decoder.singleValueContainer()
      self.object = try singleValueContainer.decode(T.self)

    }

  }

  // MARK: - License Contact Information

  // MARK: Specification

  public protocol UMLSLicenseContactInformation: UMLSContactInformation {}

  // MARK: Implementation

  public struct UMLSLicenseContact<Address: UMLSAddress & Decodable>: UMLSLicenseContactInformation,
    Decodable
  {

    public var handle: String?
    public var name: String?
    public var title: String?
    public var organization: String?
    public var address: Address
    public var telephone: String?
    public var fax: String?
    public var email: String?
    public var url: WebURL?
    public var value: String

    public init(
      handle: String? = nil, name: String? = nil, title: String? = nil, organization: String? = nil,
      address: Address, telephone: String? = nil, fax: String? = nil, email: String? = nil,
      url: WebURL? = nil, value: String
    ) {
      self.handle = handle
      self.name = name
      self.title = title
      self.organization = organization
      self.address = address
      self.telephone = telephone
      self.fax = fax
      self.email = email
      self.url = url
      self.value = value
    }

  }

#endif
