//  UMLSConceptController.swift

import Foundation

// MARK: - Identifier

/// UMLS Unique Identifier Type.
public protocol UMLSUIType {

  /// The regular expression to validate the unique identifier.
  static var pattern: String { get }

}

/// UMLS Concept Unique Identifier (CUI) type.
public struct UMLSConcept: UMLSUIType {

  public static let pattern: String = "^C\\d{7}$"

}

/// UMLS Relation Unique Identifier (RUI) type.
public struct UMLSRelation: UMLSUIType {

  public static let pattern: String = "^R\\d{9}$"

}

/// UMLS unique identifier string validation error.
public enum UMLSUIStringError: Error {
  case invalidRegularExpression(Error)
  case invalidFormat
}

/// UMLS unique identifier.
public struct UMLSUI<U: UMLSUIType>: Sendable, Equatable {
  private let string: String

  /// Initialise with formatted unique identifier string
  /// - Parameter string: Formatted unique identifier.
  /// - throws: Raise ``UMLSUIStringError`` for ill formatted string.
  public init(string: String) throws {

    let expression: NSRegularExpression
    do {
      expression = try NSRegularExpression(pattern: U.pattern)
    } catch let error {
      throw UMLSUIStringError.invalidRegularExpression(error)
    }

    let range = NSRange(location: 0, length: string.count)

    guard
      let result = expression.firstMatch(
        in: string,
        options: [],
        range: range
      )
    else {
      throw UMLSUIStringError.invalidFormat
    }

    let strings = (0..<result.numberOfRanges)
      .map(result.range(at:))
      .compactMap({ Range.init($0, in: string) })
      .map({ string[$0] })
      .map({ String($0) })

    guard strings.count == 1 else {
      throw UMLSUIStringError.invalidFormat
    }

    guard strings[0] == string else {
      throw UMLSUIStringError.invalidFormat
    }

    self.string = string

  }

}

extension UMLSUI: CustomStringConvertible {

  public var description: String {
    self.string
  }

}

/// UMLS Atom Unique Identifier (AUI) type.
public struct UMLSAtom: UMLSUIType {

  public static var pattern: String = "^A\\d{7,8}$"

}

extension UMLSUI: Decodable {

  public init(from decoder: any Decoder) throws {
    let container = try decoder.singleValueContainer()
    let string = try container.decode(String.self)
    do {
      self = try UMLSUI<U>(string: string)
    } catch let error as UMLSUIStringError {
      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: error.localizedDescription
      )
    }
  }

}

// MARK: - JSON Decodable

/// A UMLS Page object.
///
/// A refactored code for decoding response page.
public struct UMLSPage<Element: Decodable & Sendable>: Decodable, Sendable {

  /// The number of elements per page.
  public let size: Int
  /// The current page number.
  public let number: Int
  /// The total number of page available.
  public let count: Int
  /// The list of elements on current page.
  public let element: Element

  private enum CodingKeys: CodingKey {
    case result
    case pageSize
    case pageNumber
    case pageCount
  }

  /// Initializes a new instance of `UMLSPage` by decoding from the given decoder.
  /// - Parameter decoder: The decoder to read data from.
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.size = try container.decode(Int.self, forKey: .pageSize)
    self.number = try container.decode(Int.self, forKey: .pageNumber)
    self.count = try container.decode(Int.self, forKey: .pageCount)
    self.element = try container.decode(Element.self, forKey: .result)
  }

}

/// A concept information object.
public struct UMLSConceptInfo: Decodable, Sendable {

  /// A concept status.
  public enum ConceptStatus: String, Sendable, Decodable {
    case reviewed = "R"
    case unreviewed = "U"
  }

  /// The human readable name of the concept.
  public let name: String
  /// The date when concept is added to UMLS.
  public let dateAdded: Date
  /// The last major revision date.
  public let majorRevisionDate: Date
  /// Indicate if concept is suppressible.
  public let isSuppressible: Bool
  /// The concept status in the respective UMLS version.
  public let status: ConceptStatus
  /// The semantic type related to respective concept.
  public let semanticTypes: [UMLSSemanticType]
  /// The total number of atoms for respective concept.
  public let atomCount: Int
  /// The total number of content view members for respective concept.
  public let cvMemberCount: Int
  /// The total number of attribute count for respective concept.
  public let attributeCount: Int
  /// The total number of relations for respective concept.
  public let relationCount: Int

  private enum CodingKeys: CodingKey {
    case name
    case dateAdded
    case majorRevisionDate
    case suppressible
    case status
    case atomCount
    case cvMemberCount
    case attributeCount
    case relationCount
    case semanticTypes
  }

  private enum SemanticTypeCodingKeys: String, CodingKey {
    case name
  }

  public init(from decoder: any Decoder) throws {

    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decodeNonEmptyString(forKey: .name)
    self.dateAdded = try container.decode(Date.self, forKey: .dateAdded)
    self.majorRevisionDate = try container.decode(Date.self, forKey: .majorRevisionDate)
    self.isSuppressible = try container.decode(Bool.self, forKey: .suppressible)
    self.status = try container.decode(ConceptStatus.self, forKey: .status)
    self.atomCount = try container.decodeNaturalNumber(forKey: .atomCount)
    self.cvMemberCount = try container.decodeNaturalNumber(forKey: .cvMemberCount)
    self.attributeCount = try container.decodeNaturalNumber(forKey: .attributeCount)
    self.relationCount = try container.decodeNaturalNumber(forKey: .relationCount)
    // SemanticTypes
    var semanticTypesContainer = try container.nestedUnkeyedContainer(forKey: .semanticTypes)
    var semanticTypes: [UMLSSemanticType] = .init()
    while !semanticTypesContainer.isAtEnd {
      let styContainer = try semanticTypesContainer.nestedContainer(
        keyedBy: SemanticTypeCodingKeys.self)
      semanticTypes.append(try styContainer.decode(UMLSSemanticType.self, forKey: .name))
    }
    guard !semanticTypes.isEmpty else {
      throw DecodingError.dataCorruptedError(
        in: semanticTypesContainer,
        debugDescription: "At least 1 semantic type should be present for a concept.")
    }
    self.semanticTypes = semanticTypes
  }

}

/// A UMLS Definition.
///
/// Encapsulates definition of the respective concept with source.
public struct UMLSDefinition: Decodable, Sendable {

  /// The source vocabulary where respective definition belongs to.
  public let sourceVocabulary: UMLSSourceVocabulary
  /// A human readable definition from respective source vocabulary.
  public let definition: String

  enum CodingKeys: String, CodingKey {
    case sourceVocabulary = "rootSource"
    case definition = "value"
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.sourceVocabulary =
      try container
      .decode(UMLSSourceVocabulary.self, forKey: .sourceVocabulary)
    self.definition = try container.decodeNonEmptyString(forKey: .definition)
  }

}

/// UMLS concept relation.
///
/// An object encapsulates the UMLS concept relation information.
public struct UMLSRelationship: Decodable, Sendable {

  /// The relation unique identifier.
  public let ui: UMLSUI<UMLSRelation>
  /// The source asserted relationship identifier, if present.
  public let sourceUI: String?
  public let isSuppressible: Bool
  public let isObsolete: Bool
  public let isSourceOriented: Bool
  /// The name of the source vocabulary relationship.
  public let sourceVocabulary: UMLSSourceVocabulary
  /// Used to indicate that a set of relationships should be looked at in conjunction.
  public let groupID: String?
  /// The number of attributes for the relation.
  public let attributeCount: Int
  /// The human readable name of the from relation.
  public let relatedFromIdName: String
  /// The human readable name of the to relation.
  public let relatedIdName: String
  /// The relationship between from and to.
  public let relationLabel: UMLSRelationLabel
  /// The additional or semantic relationship between from and to.
  public let additionalRelationLabel: UMLSAdditionalRelationLabel

  private enum CodingKeys: String, CodingKey {
    case ui
    case sourceUI = "sourceUi"
    case isSuppressible = "suppressible"
    case isObsolete = "obsolete"
    case isSourceOriented = "sourceOriginated"
    case sourceVocabulary = "rootSource"
    case groupID = "groupId"
    case attributeCount
    case relatedFromIdName
    case relationLabel
    case additionalRelationLabel
    case relatedIdName
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.ui = try container.decode(UMLSUI<UMLSRelation>.self, forKey: .ui)
    self.sourceUI = try container.decodeNoneString(forKey: .sourceUI)
    self.isSuppressible = try container.decode(Bool.self, forKey: .isSuppressible)
    self.isObsolete = try container.decode(Bool.self, forKey: .isObsolete)
    self.isSourceOriented = try container.decode(Bool.self, forKey: .isSourceOriented)
    self.sourceVocabulary =
      try container
      .decode(UMLSSourceVocabulary.self, forKey: .sourceVocabulary)
    self.groupID = try container.decodeNoneString(forKey: .groupID)
    self.attributeCount = try container.decodeNaturalNumber(forKey: .attributeCount)
    self.relatedFromIdName = try container.decodeNonEmptyString(forKey: .relatedFromIdName)
    self.relationLabel = try container.decode(UMLSRelationLabel.self, forKey: .relationLabel)
    self.additionalRelationLabel =
      try container
      .decode(UMLSAdditionalRelationLabel.self, forKey: .additionalRelationLabel)
    self.relatedIdName = try container.decodeNonEmptyString(forKey: .relatedIdName)
  }

}

public struct UMLSAtomInfo: Decodable, Sendable {

  /// An atom unique identifier.
  public let ui: UMLSUI<UMLSAtom>
  public let isSuppressible: Bool
  public let isObsolete: Bool
  /// The source of the atom.
  public let sourceVocabulary: UMLSSourceVocabulary
  /// The term type of the atom belongs to in respective source vocabulary.
  public let termType: UMLSTermType
  /// The human readable language the name is written on.
  public let language: UMLSLanguage
  /// The human readable name of the atom.
  public let name: String

  private enum CodingKeys: String, CodingKey {
    case ui
    case isSuppressible = "suppressible"
    case isObsolete = "obsolete"
    case sourceVocabulary = "rootSource"
    case termType
    case language
    case name
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.ui = try container.decode(UMLSUI<UMLSAtom>.self, forKey: .ui)
    self.isSuppressible = try container.decodeStringBool(forKey: .isSuppressible)
    self.isObsolete = try container.decodeStringBool(forKey: .isObsolete)
    self.sourceVocabulary =
      try container
      .decode(UMLSSourceVocabulary.self, forKey: .sourceVocabulary)
    self.termType = try container.decode(UMLSTermType.self, forKey: .termType)
    self.language = try container.decode(UMLSLanguage.self, forKey: .language)
    self.name = try container.decodeNonEmptyString(forKey: .name)
  }

}

// MARK: - Parameters

public protocol UMLSConceptDefinitionParameters {

  /// The concept unique identifier.
  var concept: UMLSUI<UMLSConcept> { get }
  /// The list of source vocabularies.
  ///
  /// It's use to filter the definition if empty get definition from all the source vocabularies.
  var sourceVocabularies: [UMLSSourceVocabulary] { get }
  /// The page information in which the content is desired from.
  var page: PageInfo { get }

}

private struct __UMLSConceptDefinitionParameters: UMLSConceptDefinitionParameters {

  var concept: UMLSUI<UMLSConcept>
  var sourceVocabularies: [UMLSSourceVocabulary]
  var page: PageInfo

}

public protocol UMLSRelationParameters {
  /// A list of relationships used to filter or narrow down the result.
  ///
  /// If empty, use all the relationship labels.
  var relationLabels: [UMLSRelationLabel] { get }
  /// A list of additional relationship labels.
  ///
  /// If empty, use all the additional relationship labels.
  var additionalRelationLabels: [UMLSAdditionalRelationLabel] { get }
  /// Indicate the result also include obsolete values if any.
  var includeObsolete: Bool { get }
  /// Indicate that result also include suppressible values if any.
  var includeSuppressible: Bool { get }
  /// The page information in which the content is desired from.
  var page: PageInfo { get }
}

public protocol UMLSConceptRelationParameters: UMLSRelationParameters {
  // The concept unique identifier.
  var concept: UMLSUI<UMLSConcept> { get }
  /// The list of source vocabularies.
  ///
  /// It's use to filter the definition if empty get definition from all the source vocabularies.
  var sourceVocabularies: [UMLSSourceVocabulary] { get }
}

private struct __UMLSConceptRelationParameters: UMLSConceptRelationParameters {

  var concept: UMLSUI<UMLSConcept>

  var relationLabels: [UMLSRelationLabel]

  var additionalRelationLabels: [UMLSAdditionalRelationLabel]

  var includeObsolete: Bool

  var includeSuppressible: Bool

  var sourceVocabularies: [UMLSSourceVocabulary]

  var page: PageInfo

}

/// An protocol defining the parameters required to retrieve atoms.
public protocol UMLSAtomParameters {

  /// The source vocabularies from which to retrieve atoms.
  ///
  /// If `[]`, atoms from all available source vocabularies will be included.
  var sourceVocabularies: [UMLSSourceVocabulary] { get }

  /// The term types to filter atoms.
  ///
  /// This helps refine the search by restricting results to specific UMLS term types.
  var termTypes: [UMLSTermType] { get }

  /// The language of the atoms.
  ///
  /// If `nil`, atoms from all available languages will be included.
  var language: UMLSLanguage? { get }

  /// A flag indicating whether obsolete atoms should be included in the response.
  ///
  /// - `true`: Include obsolete and non-obsolete atoms.
  /// - `false`: Include only non-obsolete atoms.
  var includeObsolete: Bool { get }

  /// A flag indicating whether suppressible atoms should be included in the response.
  ///
  /// - `true`: Include suppressible and non-suppressible atoms.
  /// - `false`: Include only non-suppressible atoms.
  var includeSuppressible: Bool { get }

  /// The pagination information for retrieving results.
  var page: PageInfo { get }

}

/// A protocol defining the parameters requires to retrieve atoms for a UMLS concept.
public protocol UMLSConceptAtomParameters: UMLSAtomParameters {
  /// The UMLS Concept Unique Identifier (CUI) for which atoms should be retrieved.
  ///
  /// This uniquely identifies a UMLS concept and it's requires to fetch it's related atoms.
  var concept: UMLSUI<UMLSConcept> { get }
}

private struct __UMLSConceptAtomParameters: UMLSConceptAtomParameters {
  var concept: UMLSUI<UMLSConcept>
  var sourceVocabularies: [UMLSSourceVocabulary]
  var termTypes: [UMLSTermType]
  var language: UMLSLanguage?
  var includeObsolete: Bool
  var includeSuppressible: Bool
  var page: PageInfo

  init(
    concept: UMLSUI<UMLSConcept>,
    sourceVocabularies: [UMLSSourceVocabulary],
    termTypes: [UMLSTermType],
    lang: UMLSLanguage? = nil,
    includeObsolete: Bool,
    includeSuppressible: Bool,
    page: PageInfo
  ) {
    self.concept = concept
    self.sourceVocabularies = sourceVocabularies
    self.termTypes = termTypes
    self.language = lang
    self.includeObsolete = includeObsolete
    self.includeSuppressible = includeSuppressible
    self.page = page
  }

}

// MARK: Parameters builders

/// An object encapsulates pagination information.
public struct PageInfo: Equatable {
  /// The page size.
  public let size: UInt
  /// The page number.
  public let number: UInt

  public init(
    size: UInt = PageInfo.defaultSize,
    number: UInt = PageInfo.defaultNumber
  ) {
    self.size = size
    self.number = number
  }

}

extension PageInfo {
  /// The default page size
  public static let defaultSize: UInt = 25
  /// The default page number.
  public static let defaultNumber: UInt = 1
}

/// A builder class for constructing ``UMLSConceptDefinitionParameters`` instance.
public class UMLSConceptDefinitionParametersBuilder {

  private let concept: UMLSUI<UMLSConcept>
  private var source: [UMLSSourceVocabulary] = .init()
  private var page: PageInfo = .init()

  /// Initialize new builder for constructing ``UMLSConceptDefinitionParameters``.
  /// - Parameter concept: The UMLS Concept Unique Identifier (CUI) for which the definitions
  /// should be fetched.
  public init(concept: UMLSUI<UMLSConcept>) {
    self.concept = concept
  }

  /// Adds a source vocabulary to the filter list if it is not already present else skip.
  ///
  /// - Parameter sourceVocabulary: The source vocabulary to be added.
  /// - Returns: The builder instance for method chaining.
  public func addSourceVocabulary(_ sourceVocabulary: UMLSSourceVocabulary) -> Self {
    guard !source.contains(sourceVocabulary) else { return self }
    self.source.append(sourceVocabulary)
    return self
  }

  /// Removes a source vocabulary from the filter list if it exists else skip.
  ///
  /// - Parameter sourceVocabulary: The source vocabulary to be removed.
  /// - Returns: The builder instance for method chaining.
  public func removeSourceVocabulary(_ sourceVocabulary: UMLSSourceVocabulary) -> Self {
    guard let index = source.firstIndex(of: sourceVocabulary) else { return self }
    _ = self.source.remove(at: index)
    return self
  }

  /// Sets the list of source vocabularies, replacing any previously added values.
  ///
  /// - Parameter list: An array of ``UMLSSourceVocabulary`` values.
  /// - Returns: The builder instance for method chaining.
  public func setSourceVocabulary(_ sourceVocabularies: [UMLSSourceVocabulary]) -> Self {
    self.source = []
    sourceVocabularies.forEach({ _ = addSourceVocabulary($0) })
    return self
  }

  /// Sets the pagination details for retrieving concept relations.
  ///
  /// If size property is 0 then function sets `PageInfo.defaultSize`.
  /// If number property is 0 then function sets `PageInfo.defaultNumber`.
  ///
  /// - Parameter pageInfo: The ``PageInfo`` object containing pagination details.
  /// - Returns: The builder instance for method chaining.
  public func setPageInfo(_ pageInfo: PageInfo) -> Self {
    self.page = pageInfo
    return self
  }

  /// Create and returns a ``UMLSConceptDefinitionParameters`` instance with the configured
  /// parameters.
  ///
  /// - Returns: A fully configured ``UMLSConceptDefinitionParameters`` instance.
  public func build() -> UMLSConceptDefinitionParameters {
    __UMLSConceptDefinitionParameters(
      concept: self.concept,
      sourceVocabularies: self.source,
      page: self.page
    )
  }

}

/// A builder class for constructing ``UMLSConceptRelationParameters`` instance.
public class UMLSConceptRelationParametersBuilder {

  private let concept: UMLSUI<UMLSConcept>
  private var labels: [UMLSRelationLabel] = .init()
  private var additionalRelationLabels: [UMLSAdditionalRelationLabel] = .init()
  private var includeObsolete: Bool?
  private var includeSuppressible: Bool?
  private var sources: [UMLSSourceVocabulary] = .init()
  private var page: PageInfo = .init()

  /// Initialize for builder for constructing ``UMLSConceptRelationParameters``.
  /// - Parameter concept: The UMLS Concept Unique Identifier (CUI) for which the relations
  /// should be fetched.
  public init(concept: UMLSUI<UMLSConcept>) {
    self.concept = concept
  }

  /// Adds a relation label to the filter list if it is not already present else skip.
  ///
  /// - Parameter label: The relation label to be added.
  /// - Returns: The builder instance for method chaining.
  public func addRelationLabel(_ label: UMLSRelationLabel) -> Self {
    guard !labels.contains(label) else {
      return self
    }
    self.labels.append(label)
    return self
  }

  /// Removes a relation label from the filter list if it is already exists else skip.
  ///
  /// - Parameter label: The relation label to be removed.
  /// - Returns: The builder instance for method chaining.
  public func removeRelationLabel(_ label: UMLSRelationLabel) -> Self {
    guard let index = labels.firstIndex(of: label) else { return self }
    _ = labels.remove(at: index)
    return self
  }

  /// Sets the list of relation labels, replacing any previously added values.
  ///
  /// - Parameter labels: An array of ``UMLSRelationLabel`` values.
  /// - Returns: The builder instance for method chaining.
  public func setRelationLabels(_ labels: [UMLSRelationLabel]) -> Self {
    self.labels = []
    labels.forEach({ _ = addRelationLabel($0) })
    return self
  }

  /// Adds a additional relation label to the filter list if it is not already present else skip.
  ///
  /// - Parameter label: The additional relation label to be added.
  /// - Returns: The builder instance for method chaining.
  public func addAdditionalRelationLabel(_ label: UMLSAdditionalRelationLabel) -> Self {
    guard !self.additionalRelationLabels.contains(label) else {
      return self
    }
    self.additionalRelationLabels.append(label)
    return self
  }

  /// Removes a additional relation label from the filter list if it is already exists else skip.
  ///
  /// - Parameter label: The additional relation label to be removed.
  /// - Returns: The builder instance for method chaining.
  public func removeAdditionalRelationLabel(_ label: UMLSAdditionalRelationLabel) -> Self {
    guard let index = self.additionalRelationLabels.firstIndex(of: label) else {
      return self
    }
    _ = self.additionalRelationLabels.remove(at: index)
    return self
  }

  /// Sets the list of additional relation labels, replacing any previously added values.
  ///
  /// - Parameter labels: An array of ``UMLSAdditionalRelationLabel`` values.
  /// - Returns: The builder instance for method chaining.
  public func setAdditionalRelationLabels(_ labels: [UMLSAdditionalRelationLabel]) -> Self {
    self.additionalRelationLabels = []
    labels.forEach({ _ = addAdditionalRelationLabel($0) })
    return self
  }

  /// Sets the flag to include suppressible relations if any.
  ///
  /// - `true`: Include not only suppressible but also non-suppressible relations.
  /// - `false`: Include only non-suppressible relations.
  /// - Parameter bool: A suppressible flag.
  /// - Returns: The builder instance for method chaining.
  public func setIncludeSuppressible(_ bool: Bool) -> Self {
    self.includeSuppressible = bool
    return self
  }

  /// Sets the flag to include obsolete relations if any.
  ///
  /// - `true`: Include not only obsolete but also non-obsolete relations.
  /// - `false`: Include only non-obsolete relations.
  /// - Parameter bool: A obsolete flag.
  /// - Returns: The builder instance for method chaining.
  public func setIncludeObsolete(_ bool: Bool) -> Self {
    self.includeObsolete = bool
    return self
  }

  /// Adds a source vocabulary to the filter list if it is not already present else skip.
  ///
  /// - Parameter sourceVocabulary: The source vocabulary to be added.
  /// - Returns: The builder instance for method chaining.
  public func addSourceVocabulary(_ sourceVocabulary: UMLSSourceVocabulary) -> Self {
    guard !sources.contains(sourceVocabulary) else {
      return self
    }
    self.sources.append(sourceVocabulary)
    return self
  }

  /// Removes a source vocabulary from the filter list if it exists else skip.
  ///
  /// - Parameter sourceVocabulary: The source vocabulary to be removed.
  /// - Returns: The builder instance for method chaining.
  public func removeSourceVocabulary(_ sourceVocabulary: UMLSSourceVocabulary) -> Self {
    guard let index = sources.firstIndex(of: sourceVocabulary) else { return self }
    _ = sources.remove(at: index)
    return self
  }

  /// Sets the list of source vocabularies, replacing any previously added values.
  ///
  /// - Parameter list: An array of ``UMLSSourceVocabulary`` values.
  /// - Returns: The builder instance for method chaining.
  public func setSourceVocabulary(_ list: [UMLSSourceVocabulary]) -> Self {
    self.sources = []
    list.forEach({ _ = addSourceVocabulary($0) })
    return self
  }

  /// Sets the pagination details for retrieving concept relations.
  ///
  /// If size property is 0 then function sets `PageInfo.defaultSize`.
  /// If number property is 0 then function sets `PageInfo.defaultNumber`.
  ///
  /// - Parameter pageInfo: The ``PageInfo`` object containing pagination details.
  /// - Returns: The builder instance for method chaining.
  public func setPageInfo(_ pageInfo: PageInfo) -> Self {
    self.page = .init(
      size: pageInfo.size == 0 ? PageInfo.defaultSize : pageInfo.size,
      number: pageInfo.number == 0 ? PageInfo.defaultNumber : pageInfo.number
    )
    return self
  }

  /// Create and returns a ``UMLSConceptRelationParameters`` instance with the configured
  /// parameters.
  ///
  /// - Returns: A fully configured ``UMLSConceptRelationParameters`` instance.
  public func build() -> UMLSConceptRelationParameters {
    __UMLSConceptRelationParameters(
      concept: self.concept,
      relationLabels: self.labels,
      additionalRelationLabels: self.additionalRelationLabels,
      includeObsolete: self.includeObsolete ?? false,
      includeSuppressible: self.includeSuppressible ?? false,
      sourceVocabularies: self.sources,
      page: self.page)
  }

}

/// A builder class for constructing ``UMLSConceptAtomParameters`` instance.
public class UMLSConceptAtomParametersBuilder {

  private let concept: UMLSUI<UMLSConcept>
  private var sources: [UMLSSourceVocabulary] = .init()
  private var termTypes: [UMLSTermType] = .init()
  private var lang: UMLSLanguage?
  private var includeObsolete: Bool?
  private var includeSuppressible: Bool?
  private var page: PageInfo?

  /// Initialize for builder for constructing ``UMLSConceptAtomParameters``.
  /// - Parameter concept: The UMLS Concept Unique Identifier (CUI) for which the atoms
  /// should be fetched.
  public init(concept: UMLSUI<UMLSConcept>) {
    self.concept = concept
  }

  /// Sets the list of source vocabularies, replacing any previously added values.
  ///
  /// - Parameter list: An array of ``UMLSSourceVocabulary`` values.
  /// - Returns: The builder instance for method chaining.
  public func setSourceVocabularies(_ list: [UMLSSourceVocabulary]) -> Self {
    self.sources = []
    list.forEach({ _ = self.addSourceVocabulary($0) })
    return self
  }

  /// Adds a source vocabulary to the filter list if it is not already present else skip.
  ///
  /// - Parameter sourceVocabulary: The source vocabulary to be added.
  /// - Returns: The builder instance for method chaining.
  public func addSourceVocabulary(_ sourceVocabulary: UMLSSourceVocabulary) -> Self {
    guard !sources.contains(sourceVocabulary) else { return self }
    sources.append(sourceVocabulary)
    return self
  }

  /// Removes a source vocabulary from the filter list if it exists else skip.
  ///
  /// - Parameter sourceVocabulary: The source vocabulary to be removed.
  /// - Returns: The builder instance for method chaining.
  public func removeSourceVocabulary(_ sourceVocabulary: UMLSSourceVocabulary) -> Self {
    guard let index = sources.firstIndex(of: sourceVocabulary) else { return self }
    _ = sources.remove(at: index)
    return self
  }

  /// Sets the list of term types, replacing any previously added values.
  ///
  /// - Parameter list: An array of ``UMLSSourceVocabulary`` values.
  /// - Returns: The builder instance for method chaining.
  public func setTermTypes(_ list: [UMLSTermType]) -> Self {
    self.termTypes = []
    list.forEach({ _ = addTermType($0) })
    return self
  }

  /// Adds a term type to the filter if it is not already present else skip.
  ///
  /// - Parameter termType: The term type to be added.
  /// - Returns: The builder instance of method chaining.
  public func addTermType(_ termType: UMLSTermType) -> Self {
    guard !termTypes.contains(termType) else { return self }
    termTypes.append(termType)
    return self
  }

  /// Removes a term type to the filter if it is already present else skip.
  ///
  /// - Parameter termType: The term type to be removed.
  /// - Returns: The builder instance of method chaining.
  public func removeTermType(_ termType: UMLSTermType) -> Self {
    guard let index = termTypes.firstIndex(of: termType) else { return self }
    termTypes.remove(at: index)
    return self
  }

  /// Sets the language for the atoms.
  ///
  /// If sets `nil`, atoms from all available languages will be included.
  ///
  /// - Parameter language: The language for the atoms or nil.
  /// - Returns: The builder instance of method chaining.
  public func setLanguage(_ language: UMLSLanguage?) -> Self {
    self.lang = language
    return self
  }

  /// Sets the flag to include obsolete relations if any.
  ///
  /// - `true`: Include not only obsolete but also non-obsolete relations.
  /// - `false`: Include only non-obsolete relations.
  /// - Parameter bool: A obsolete flag.
  /// - Returns: The builder instance for method chaining.
  public func setIncludeObsolete(_ bool: Bool) -> Self {
    self.includeObsolete = bool
    return self
  }

  /// Sets the flag to include suppressible relations if any.
  ///
  /// - `true`: Include not only suppressible but also non-suppressible relations.
  /// - `false`: Include only non-suppressible relations.
  /// - Parameter bool: A suppressible flag.
  /// - Returns: The builder instance for method chaining.
  public func setIncludeSuppressible(_ bool: Bool) -> Self {
    self.includeSuppressible = bool
    return self
  }

  /// Sets the pagination details for retrieving concept relations.
  ///
  /// If size property is 0 then function sets `PageInfo.defaultSize`.
  /// If number property is 0 then function sets `PageInfo.defaultNumber`.
  ///
  /// - Parameter pageInfo: The ``PageInfo`` object containing pagination details.
  /// - Returns: The builder instance for method chaining.
  public func setPageInfo(_ pageInfo: PageInfo) -> Self {
    self.page = pageInfo
    return self
  }

  /// Create and returns a ``UMLSConceptAtomParameters`` instance with the configured
  /// parameters.
  ///
  /// - Returns: A fully configured ``UMLSConceptAtomParameters`` instance.
  public func build() -> UMLSConceptAtomParameters {
    __UMLSConceptAtomParameters(
      concept: self.concept,
      sourceVocabularies: self.sources,
      termTypes: self.termTypes,
      lang: self.lang,
      includeObsolete: self.includeObsolete ?? false,
      includeSuppressible: self.includeSuppressible ?? false,
      page: self.page ?? .init()
    )
  }

}

// MARK: - Concept Controller

public protocol UMLSConceptController {

  /// Retrieves detailed information about a given UMLS concept.
  ///
  /// - Parameter ui: The unique identifier (``UMLSUI<UMLSConcept>``) of the concept to retrieve.
  /// - Returns: A ``UMLSPage<UMLSConceptInfo>`` containing information about the requested concept.
  /// - Throws: Raises ``UMLSError``.
  func info(of ui: UMLSUI<UMLSConcept>) async throws -> UMLSPage<UMLSConceptInfo>

  /// Fetches definitions associated with a UMLS concept using the specified parameters.
  ///
  /// - Parameter parameters: The parameters (``UMLSConceptDefinitionParameters``) used to filter and retrieve definitions.
  /// - Returns: A ``UMLSPage<[UMLSDefinition]>`` containing the retrieved definitions.
  /// - Throws: Raises ``UMLSError``.
  func definitions(using parameters: UMLSConceptDefinitionParameters) async throws -> UMLSPage<
    [UMLSDefinition]
  >

  /// Retrieves relationships for a given UMLS concept using the specified parameters.
  ///
  /// - Parameter parameters: The parameters (``UMLSConceptRelationParameters``) used to filter and retrieve relationships.
  /// - Returns: A ``UMLSPage<[UMLSRelationship]>`` containing the concept's relationships.
  /// - Throws: Raises ``UMLSError``.
  func relations(using parameters: UMLSConceptRelationParameters) async throws -> UMLSPage<
    [UMLSRelationship]
  >

  /// Fetches atoms (lexical variants) associated with a UMLS concept using the specified parameters.
  ///
  /// - Parameter parameters: The parameters (``UMLSConceptAtomParameters``) used to filter and retrieve atoms.
  /// - Returns: A ``UMLSPage<[UMLSAtomInfo]>`` containing atom-related information.
  /// - Throws: Raises ``UMLSError``.
  func atoms(using parameters: UMLSConceptAtomParameters) async throws -> UMLSPage<[UMLSAtomInfo]>

  /// Retrieves the preferred atom information for a given UMLS concept.
  ///
  /// - Parameter concept: The unique identifier (``UMLSUI<UMLSConcept>``) of the concept.
  /// - Returns: A ``UMLSPage<UMLSAtomInfo>`` containing the preferred atom information.
  /// - Throws: Raises ``UMLSError``.
  func preferred(_ concept: UMLSUI<UMLSConcept>) async throws -> UMLSPage<UMLSAtomInfo>

}
