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

#endif
