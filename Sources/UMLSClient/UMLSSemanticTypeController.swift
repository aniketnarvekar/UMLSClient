#if (SemanticType)

  // MARK: - Identifier

  public struct UMLSTUI: UMLSUIType {

    public static var pattern: String = "^T\\d{3}$"

  }

  // MARK: - JSON Decoder

  public enum UMLSSemanticValue {
    /// A semantic type.
    case semanticType(UMLSSemanticType)
    /// A semantic type relation label.
    case relation(UMLSSemanticTypeRelationLabel)
  }

  extension UMLSSemanticValue: Decodable {
    public init(from decoder: any Decoder) throws {
      let container = try decoder.singleValueContainer()
      let string = try container.decode(String.self)
      if let semanticType = UMLSSemanticType(rawValue: string) {
        self = .semanticType(semanticType)
      } else if let semanticTypeRelationlabel = UMLSSemanticTypeRelationLabel(rawValue: string) {
        self = .relation(semanticTypeRelationlabel)
      } else {
        throw DecodingError.dataCorruptedError(
          in: container,
          debugDescription:
            "Cannot initialize UMLSSemanticValue from invalid String value \(string)")
      }
    }
  }

  /// A semantic type forward relation info
  public struct UMLSSemanticTypeRelationInfo: Decodable {
    /// A type of relation between the respective relation with request semantic type.
    public let type: UMLSSemanticTypeRelationLabel
    /// A relation object
    public let relation: UMLSSemanticValue
    /// A flag to determine relation state
    public let flag: UMLSSemanticTypeFlag
  }

  /// An semantic type inverse relation info
  public struct UMLSSemanticTypeInverseRelationInfo: Decodable {
    /// A type of relation between the respective relation with request semantic type.
    public let type: UMLSSemanticTypeRelationLabel
    /// A flag to determine relation state.
    public let flag: UMLSSemanticTypeFlag
    /// A relation object.
    public let relation: UMLSSemanticValue

    private enum CodingKeys: String, CodingKey {
      case type
      case flag
      case relation = "inverseRelation"
    }

  }

  /// An object represents inherited semantic type relation information.
  public struct UMLSSemanticTypeInheritedRelationInfo: Decodable {

    /// A type of relation between the respective relation with requested semantic type.
    public let type: UMLSSemanticTypeRelationLabel
    /// A relation name.
    public let relation: UMLSSemanticValue

    private enum CodingKeys: String, CodingKey {
      case type = "relationType"
      case relation = "relation2"
    }

  }

  /// An object represents inverse inherited semantic type relation information.
  public struct UMLSSemanticTypeInverseInheritedRelationInfo: Decodable {
    /// A type of relation between the respective relation with requested semantic type.
    public let type: UMLSSemanticTypeRelationLabel
    /// A relation name.
    public let relation: UMLSSemanticValue

    private enum CodingKeys: String, CodingKey {
      case type = "relationType"
      case relation = "relation1"
    }

  }

  /// A UMLS semantic type information group.
  public struct UMLSSemanticTypeGroupInfo: Decodable {
    /// A semantic type group name abbraviation
    public let abbreviation: String
    /// A long-common name.
    public let name: String
    /// A total number of semantic type present in the group.
    public let count: UInt

    private enum CodingKeys: String, CodingKey {
      case abbreviation = "abbreviation"
      case name = "expandedForm"
      case count = "semanticTypeCount"
    }
  }

  /// An object encapsulates UMLS semantic type information.
  public struct UMLSSemanticTypeInfo: Decodable {
    /// A semantic type name abbraviation.
    public let abbreviation: String
    /// A unique identifier
    public let ui: UMLSUI<UMLSTUI>
    /// A definition of respecitive semantic type.
    public let definition: String
    /// A usage note if present nil.
    public let usageNote: String?
    /// The value of the respecitve ``ui``.
    public let name: UMLSSemanticValue
    /// A list of forward realtions.
    public let relations: [UMLSSemanticTypeRelationInfo]
    /// A list of inverse relations if any.
    public let inverseRelations: [UMLSSemanticTypeInverseRelationInfo]
    /// A list of inherited relations.
    public let inheritedRelations: [UMLSSemanticTypeInheritedRelationInfo]
    /// A list of inverse inherited relations.
    public let inverseInheritedRelations: [UMLSSemanticTypeInverseInheritedRelationInfo]
    /// Total number of childrens for respective ``ui``.
    public let count: UInt
    /// A semantic type group information if any.
    public let group: UMLSSemanticTypeGroupInfo?

    private enum CodingKeys: String, CodingKey {
      case abbreviation
      case ui
      case definition
      case usageNote
      case name
      case relations
      case inverseRelations
      case inheritedRelations
      case inverseInheritedRelations
      case count = "childCount"
      case group = "semanticTypeGroup"
    }

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.abbreviation = try container.decode(String.self, forKey: .abbreviation)
      self.ui = try container.decode(UMLSUI<UMLSTUI>.self, forKey: .ui)
      self.definition = try container.decode(String.self, forKey: .definition)
      let note = try container.decode(String.self, forKey: .usageNote)
      self.usageNote = !["", .none].contains(note) ? note : nil
      self.name = try container.decode(UMLSSemanticValue.self, forKey: .name)
      self.relations = try container.decode([UMLSSemanticTypeRelationInfo].self, forKey: .relations)
      self.inverseRelations = try container.decode(
        [UMLSSemanticTypeInverseRelationInfo].self, forKey: .inverseRelations)
      self.inheritedRelations = try container.decode(
        [UMLSSemanticTypeInheritedRelationInfo].self, forKey: .inheritedRelations)
      self.inverseInheritedRelations = try container.decode(
        [UMLSSemanticTypeInverseInheritedRelationInfo].self, forKey: .inverseInheritedRelations)
      self.count = try container.decode(UInt.self, forKey: .count)
      self.group = try container.decode(UMLSSemanticTypeGroupInfo.self, forKey: .group)
    }

  }

  // MARK: - SemanticTypeController

  public protocol UMLSSemanticTypeController {

    func info(of ui: UMLSUI<UMLSTUI>) async throws -> UMLSPage<UMLSSemanticTypeInfo>

  }

#endif
