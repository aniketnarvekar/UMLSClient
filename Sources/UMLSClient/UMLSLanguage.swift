// UMLSLanguage.swift

import Foundation
import WebURL

#if SourceVocabulary

  // MARK: - Object type enumeration

  public enum UMLSObject: String, Codable {
    case language = "Language"
    case contentInfo = "ContactInformation"
    case sourceVocabulary = "RootSource"
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

  extension UMLSLanguageInfo: Decodable, Sendable {

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

  public struct UMLSLanguageTypeObject<U: UMLSLanguage & Decodable & Sendable>: UMLSLanguageType,
    Decodable, Sendable
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

  public struct UMLSPostalAddress: UMLSAddress, Decodable, Sendable {

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
      if let urlString = urlStringOrNull {
        url = WebURL(urlString)
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
  public struct UMLSCreatorContact<Address: UMLSAddress & Decodable & Sendable>:
    UMLSCreatorContactInformation,
    Decodable & Sendable
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

  public protocol UMLSContactInformationType {
    associatedtype Object: UMLSContactInformation
    var object: Object { get }
  }

  public struct UMLSContactInformationTypeObject<
    T: UMLSContactInformation & Decodable & Sendable
  >: UMLSContactInformationType, Decodable, Sendable {
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

  public struct UMLSLicenseContact<Address: UMLSAddress & Decodable & Sendable>:
    UMLSLicenseContactInformation,
    Decodable, Sendable
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

  // MARK: - Source Vocabulary

  public protocol UMLSSourceVocabularyInformation {
    associatedtype Language: UMLSLanguageType
    associatedtype CreatorContactType: UMLSContactInformationType
    where CreatorContactType.Object: UMLSCreatorContactInformation
    associatedtype LicenseContactType: UMLSContactInformationType
    where LicenseContactType.Object: UMLSLicenseContactInformation
    var abbreviation: String { get }
    var expandedForm: String { get }
    var family: String { get }
    var language: Language { get }
    var restrictionLevel: UInt8 { get }
    var acquisitionContact: String? { get }
    var contentContact: CreatorContactType { get }
    var licenseContact: LicenseContactType { get }
    var contextType: UMLSContextType { get }
    var shortName: String { get }
    var hierarchicalName: String? { get }
    var preferredName: String { get }
    var synonymousNames: String? { get }
  }

  public struct UMLSSourceVocabularyInfo<
    Language: UMLSLanguage & Decodable & Sendable,
    CreatorContact: UMLSCreatorContactInformation & Decodable & Sendable,
    LicenseContact: UMLSLicenseContactInformation & Decodable & Sendable
  >: UMLSSourceVocabularyInformation, Decodable, Sendable {
    public var abbreviation: String
    public var expandedForm: String
    public var family: String
    public var language: UMLSLanguageTypeObject<Language>
    public var restrictionLevel: UInt8
    public var acquisitionContact: String?
    public var contentContact: UMLSContactInformationTypeObject<CreatorContact>
    public var licenseContact: UMLSContactInformationTypeObject<LicenseContact>
    public var contextType: UMLSContextType
    public var shortName: String
    public var hierarchicalName: String?
    public var preferredName: String
    public var synonymousNames: String?

    private enum CodingKeys: CodingKey {
      case abbreviation
      case expandedForm
      case family
      case language
      case restrictionLevel
      case acquisitionContact
      case contentContact
      case licenseContact
      case contextType
      case shortName
      case hierarchicalName
      case preferredName
      case synonymousNames
    }

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)

      guard let abbreviation = try container.decodeNoneString(forKey: .abbreviation) else {
        throw DecodingError.dataCorruptedError(forKey: .abbreviation, in: container, debugDescription: "Invalid abbreviation \"NONE\" or \"\".")
      }
      self.abbreviation = abbreviation.trimmingCharacters(in: .whitespacesAndNewlines)

      guard let expandedForm = try container.decodeNoneString(forKey: .expandedForm) else {
        throw DecodingError.dataCorruptedError(forKey: .expandedForm, in: container, debugDescription: "Invalid expandedForm \"NONE\" or \"\".")
      }
      self.expandedForm = expandedForm.trimmingCharacters(in: .whitespacesAndNewlines)

      guard let family = try container.decodeNoneString(forKey: .family) else {
        throw DecodingError.dataCorruptedError(forKey: .family, in: container, debugDescription: "Invalid family \"NONE\" or \"\".")
      }
      self.family = family.trimmingCharacters(in: .whitespacesAndNewlines)

      self.language = try container.decode(UMLSLanguageTypeObject<Language>.self, forKey: .language)
      self.restrictionLevel = try container.decode(UInt8.self, forKey: .restrictionLevel)
      self.acquisitionContact = try container.decodeNoneString(forKey: .acquisitionContact)?.trimmingCharacters(in: .whitespacesAndNewlines)
      self.contentContact = try container.decode(
        UMLSContactInformationTypeObject<CreatorContact>.self, forKey: .contentContact)
      self.licenseContact = try container.decode(
        UMLSContactInformationTypeObject<LicenseContact>.self, forKey: .licenseContact)

      let contextTypeString = try container.decode(String.self, forKey: .contextType).trimmingCharacters(in: .whitespacesAndNewlines)
      guard let contextType = UMLSContextType(rawValue: contextTypeString) else {
        throw DecodingError.dataCorruptedError(forKey: .contextType, in: container, debugDescription: "Unsupported contextType \(contextTypeString)")
      }
      self.contextType = contextType

      guard let shortName = try container.decodeNoneString(forKey: .shortName) else {
        throw DecodingError.dataCorruptedError(forKey: .shortName, in: container, debugDescription: "Invalid shortName \"NONE\" or \"\".")
      }
      self.shortName = shortName.trimmingCharacters(in: .whitespacesAndNewlines)

      self.hierarchicalName = try container.decodeNoneString(forKey: .hierarchicalName)?.trimmingCharacters(in: .whitespacesAndNewlines)
      guard let preferredName = try container.decodeNoneString(forKey: .preferredName) else {
        throw DecodingError.dataCorruptedError(forKey: .preferredName, in: container, debugDescription: "Invalid preferredName \"NONE\" or \"\".")
      }
      self.preferredName = preferredName.trimmingCharacters(in: .whitespacesAndNewlines)

      self.synonymousNames = try container.decodeNoneString(forKey: .synonymousNames)?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
  }

  // MARK: - Source vocabulary type

  public protocol UMLSSourceVocabularyType: UMLSTypeDecodable
  where Self.Object: UMLSSourceVocabularyInformation {}

  // MARK: Implementation

  public struct UMLSSourceVocabularyTypeObject<
    T: UMLSSourceVocabularyInformation & Decodable & Sendable
  >: UMLSSourceVocabularyType, Sendable {
    public var object: T

    private enum CodingKeys: CodingKey {
      case classType
    }

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      let classType = try container.decode(UMLSObject.self, forKey: .classType)
      guard classType == .sourceVocabulary else {
        throw DecodingError.dataCorruptedError(
          forKey: .classType, in: container, debugDescription: "Unsupported class type.")
      }

      let singleValueContainer = try decoder.singleValueContainer()
      self.object = try singleValueContainer.decode(T.self)
    }
  }

#endif
