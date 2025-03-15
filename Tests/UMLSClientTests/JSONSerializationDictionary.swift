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

    static func address(
      address1: JSONValue<Any> = .present(String.randomStringWithNone()),
      address2: JSONValue<Any> = .present(String.randomStringWithNone()),
      city: JSONValue<Any> = .present(String.randomStringWithNone()),
      stateOrProvince: JSONValue<Any> = .present(String.randomStringWithNone()),
      country: JSONValue<Any> = .present(String.randomStringWithNone()),
      zipCode: JSONValue<Any> = .present(String.randomStringWithNone())
    ) -> [String: Any] {
      dictionary([
        "address1": address1,
        "address2": address2,
        "city": city,
        "stateOrProvince": stateOrProvince,
        "country": country,
        "zipCode": zipCode,
      ])
    }

    static func creatorContact(
      classType: JSONValue<Any> = .present("ContactInformation"),
      handle: JSONValue<Any> = .present(String.randomNumericString(of: 10)),
      name: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      title: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      organization: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      address1: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      address2: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      city: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      stateOrProvince: JSONValue<Any> = .present(String.randomNumericString(of: 2)),
      country: JSONValue<Any> = .present(String.randomNumericString(of: 5)),
      zipCode: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 5)),
      telephone: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      fax: JSONValue<Any> = .present(String.randomNumericString(of: 10)),
      email: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
      url: JSONValue<Any> = .present("https://localhost:8080/"),
      value: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10))
    ) -> [String: Any] {
      dictionary([
        "classType": classType,
        "handle": handle,
        "name": name,
        "title": title,
        "organization": organization,
        "address1": address1,
        "address2": address2,
        "city": city,
        "stateOrProvince": stateOrProvince,
        "country": country,
        "zipCode": zipCode,
        "telephone": telephone,
        "fax": fax,
        "email": email,
        "url": url,
        "value": value,
      ])
    }

  #endif

}
