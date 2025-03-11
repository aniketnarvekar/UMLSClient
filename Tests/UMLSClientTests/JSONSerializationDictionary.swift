//  JSONSerializationDictionary.swift

import Foundation

@testable import UMLSClient

enum JSONSerializationDictionary {

  private static func dictionary(_ dictionary: [String: JSONValue<Any>]) -> [String: Any] {
    var dict: [String: Any] = .init()
    for (key, value) in dictionary {
      if case JSONValue<Any>.present(let value) = value {
        dict[key] = value != nil ? value! : NSNull()
      }
    }
    return dict
  }

  static func semanticTypeRelationInfo(
    type: JSONValue<Any> = .present(UMLSSemanticTypeRelationLabel.random().rawValue),
    relation: JSONValue<Any> = .present(UMLSSemanticValue.random().rawValue),
    flag: JSONValue<Any> = .present(UMLSSemanticTypeFlag.random().rawValue)
  ) -> [String: Any] {
    dictionary([
      "type": type,
      "relation": relation,
      "flag": flag,
    ])
  }

  static func semanticTypeInverseRelationInfo(
    type: JSONValue<Any> = .present(UMLSSemanticTypeRelationLabel.random().rawValue),
    relation: JSONValue<Any> = .present(UMLSSemanticValue.random().rawValue),
    flag: JSONValue<Any> = .present(UMLSSemanticTypeFlag.random().rawValue)
  ) -> [String: Any] {
    dictionary([
      "type": type,
      "inverseRelation": relation,
      "flag": flag,
    ])
  }

  static func semanticTypeInheritedRelationInfo(
    type: JSONValue<Any> = .present(UMLSSemanticTypeRelationLabel.random().rawValue),
    relation: JSONValue<Any> = .present(UMLSSemanticValue.random().rawValue)
  ) -> [String: Any] {
    dictionary([
      "relationType": type,
      "relation2": relation,
    ])
  }

  static func semanticTypeInverseInheritedRelationInfo(
    type: JSONValue<Any> = .present(
      UMLSSemanticTypeRelationLabel.random().rawValue
    ),
    relation: JSONValue<Any> = .present(UMLSSemanticValue.random().rawValue)
  ) -> [String: Any] {
    dictionary([
      "relationType": type,
      "relation1": relation,
    ])
  }

  static func semanticTypeGroupInfo(
    abbreviation: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    name: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    count: JSONValue<Any> = .present(UInt.random(in: 0..<UInt.max))
  ) -> [String: Any] {
    dictionary([
      "abbreviation": abbreviation,
      "expandedForm": name,
      "semanticTypeCount": count,
    ])
  }

  static func semanticTypeInfo(
    abbreviation: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    ui: JSONValue<Any> = .present(UMLSUI<UMLSTUI>.random().description),
    definition: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    usageNote: JSONValue<Any> = .present(
      [.none, "", .randomAlphaNumericString(of: 10)].randomElement()!),
    name: JSONValue<Any> = .present(UMLSSemanticValue.random().rawValue),
    count: JSONValue<Any> = .present(UInt.random(in: 0..<UInt.max)),
    relations: JSONValue<Any> = .present(
      (0..<UInt.random(in: 0..<20)).map({ _ in semanticTypeRelationInfo() })
    ),
    inverseRelations: JSONValue<Any> = .present(
      (0..<UInt.random(in: 0..<20)).map({ _ in semanticTypeInverseRelationInfo() })
    ),
    inheritedRelations: JSONValue<Any> = .present(
      (0..<UInt.random(in: 0..<20)).map({ _ in semanticTypeInheritedRelationInfo() })
    ),
    inverseInheritedRelations: JSONValue<Any> = .present(
      (0..<UInt.random(in: 0..<20)).map({ _ in semanticTypeInverseInheritedRelationInfo() })
    ),
    group: JSONValue<Any> = .present(semanticTypeGroupInfo())
  ) -> [String: Any] {
    dictionary([
      "abbreviation": abbreviation,
      "ui": ui,
      "definition": definition,
      "usageNote": usageNote,
      "name": name,
      "childCount": count,
      "relations": relations,
      "inverseRelations": inverseRelations,
      "inheritedRelations": inheritedRelations,
      "inverseInheritedRelations": inverseInheritedRelations,
      "semanticTypeGroup": group,
    ])
  }

  #if SourceVocabulary

    static func languageInfo(
      classType: JSONValue<Any> = .present(UMLSObject.language.rawValue),
      abbreviation: JSONValue<Any> = .present(UMLSLanguageAbbreviation.random().rawValue),
      name: JSONValue<Any> = .present(UMLSLanguageName.random().rawValue)
    ) -> [String: Any] {
      dictionary([
        "classType": classType,
        "abbreviation": abbreviation,
        "expandedForm": name,
      ])
    }

  #endif

}
