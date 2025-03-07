// DecodeSemanticTypeInfoTests.swift

import XCTest

@testable import UMLSClient

final class DecodeSemanticTypeInfoTests: XCTestCase, XCTDecodingErrorAssertion {

  typealias Element = UMLSSemanticTypeInfo

  var jsonDecoder: JSONDecoder!

  override func setUp() {
    self.jsonDecoder = .init()
  }

  func semanticTypeInfo(
    abbreviation: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    ui: JSONValue<Any> = .present(UMLSUI<UMLSTUI>.random().description),
    definition: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    usageNote: JSONValue<Any> = .present(
      [.none, "", .randomAlphaNumericString(of: 10)].randomElement()!),
    name: JSONValue<Any> = .present(UMLSSemanticValue.random().rawValue),
    count: JSONValue<Any> = .present(UInt.random(in: 0..<UInt.max)),
    relations: JSONValue<Any> = .present(
      (0..<UInt.random(in: 0..<20)).map({ _ in
        JSONSerializationDictionary.semanticTypeRelationInfo()
      })
    ),
    inverseRelations: JSONValue<Any> = .present(
      (0..<UInt.random(in: 0..<20)).map({ _ in
        JSONSerializationDictionary.semanticTypeInverseRelationInfo()
      })
    ),
    inheritedRelations: JSONValue<Any> = .present(
      (0..<UInt.random(in: 0..<20)).map({ _ in
        JSONSerializationDictionary.semanticTypeInheritedRelationInfo()
      })
    ),
    inverseInheritedRelations: JSONValue<Any> = .present(
      (0..<UInt.random(in: 0..<20)).map({ _ in
        JSONSerializationDictionary.semanticTypeInverseInheritedRelationInfo()
      })
    ),
    group: JSONValue<Any> = .present(JSONSerializationDictionary.semanticTypeGroupInfo())
  ) -> Data {
    let dictionary = JSONSerializationDictionary.semanticTypeInfo(
      abbreviation: abbreviation,
      ui: ui, definition: definition, usageNote: usageNote, name: name, count: count,
      relations: relations, inverseRelations: inverseRelations,
      inheritedRelations: inheritedRelations,
      inverseInheritedRelations: inverseInheritedRelations,
      group: group
    )
    return try! JSONSerialization.data(withJSONObject: dictionary)
  }

  func testDecodeNonEmptyAbbreviation() throws {
    let abbreviation = String.randomAlphaNumericString(of: 5)
    let result = try toObject(
      from: semanticTypeInfo(abbreviation: .present(abbreviation))
    ).abbreviation
    XCTAssertFalse(result.isEmpty)
    XCTAssertEqual(result, abbreviation)
  }

  func testDecodeEmptyAbbreviation() throws {
    dataCorrupted(from: semanticTypeInfo(abbreviation: .present(""))) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "abbreviation")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testDecodeMissingAbbreviation() throws {
    keyNotFound(from: semanticTypeInfo(abbreviation: .absent)) { key, context in
      XCTAssertEqual(key.stringValue, "abbreviation")
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertNil(context.underlyingError)
    }
  }

  func testDecodeInvalidTypeAbbreviation() throws {
    typeMismatch(
      from: semanticTypeInfo(abbreviation: .present(Int.random(in: Int.min...Int.max)))
    ) { dataType, context in
      XCTAssert(dataType is String.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "abbreviation")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testNullAbbreviation() throws {
    valueNotFound(from: semanticTypeInfo(abbreviation: .present(nil))) { dataType, context in
      XCTAssert(dataType is String.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "abbreviation")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testSupprotedFormatUI() throws {
    let uiString = "T\((100..<1000).randomElement()!)"
    let result = try toObject(from: semanticTypeInfo(ui: .present(uiString))).ui
    XCTAssertEqual(result.description, uiString)
  }

  func testMissingUI() throws {
    keyNotFound(from: semanticTypeInfo(ui: .absent)) { key, context in
      XCTAssertEqual(key.stringValue, "ui")
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertNil(context.underlyingError)
    }
  }

  func testNullUI() throws {
    valueNotFound(from: semanticTypeInfo(ui: .present(nil))) { dataType, context in
      XCTAssert(dataType is String.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "ui")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testUnsupportedFormatUI() throws {
    let strings = [
      "", "C123", "123C", "1C23", "123", "1234", "12345",
    ]
    for string in strings {
      dataCorrupted(from: semanticTypeInfo(ui: .present(string))) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "ui")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testInvalidTypeUI() throws {
    let values: [Any] = [
      Int.random(in: 100..<1000),
      [:],
      Float.random(in: 100.0..<1000.0),
      [],
    ]
    for value in values {
      typeMismatch(from: semanticTypeInfo(ui: .present(value))) { dataType, context in
        XCTAssert(dataType is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
      }
    }
  }

  func testNonEmptyStringDefinition() throws {
    let string = String.randomAlphaNumericString(of: 10)
    let result = try toObject(from: semanticTypeInfo(definition: .present(string))).definition
    XCTAssertFalse(result.isEmpty)
    XCTAssertEqual(result, string)
  }

  func testEmptyStringDefinition() throws {
    dataCorrupted(from: semanticTypeInfo(definition: .present(""))) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "definition")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testNullDefinition() throws {
    valueNotFound(from: semanticTypeInfo(definition: .present(nil))) { dataType, context in
      XCTAssert(dataType is String.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "definition")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testMissingDefinition() throws {
    keyNotFound(from: semanticTypeInfo(definition: .absent)) { key, context in
      XCTAssertEqual(key.stringValue, "definition")
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertNil(context.underlyingError)
    }
  }

  func testInvalidTypeDefinition() throws {
    let values: [Any] = [
      Int.random(in: Int.min...Int.max),
      [:],
      Float.random(in: 100.0..<1000.0),
      [],
    ]
    for value in values {
      typeMismatch(from: semanticTypeInfo(definition: .present(value))) { dataType, context in
        XCTAssert(dataType is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "definition")
      }
    }
  }

  func testNonEmptyUsageNote() throws {
    let string = String.randomAlphaNumericString(of: 10)
    let result = try toObject(from: semanticTypeInfo(usageNote: .present(string))).usageNote
    XCTAssertNotNil(result)
    XCTAssertFalse(result!.isEmpty)
    XCTAssertEqual(result!, string)
  }

  func testNilUsageNote() throws {
    let strings = ["", .none]
    for string in strings {
      let result = try toObject(from: semanticTypeInfo(usageNote: .present(string))).usageNote
      XCTAssertNil(result)
    }
  }

  func testNullUsageNote() throws {
    valueNotFound(from: semanticTypeInfo(usageNote: .present(nil))) { dataType, context in
      XCTAssert(dataType is String.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "usageNote")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testMissingUsageNote() throws {
    keyNotFound(from: semanticTypeInfo(usageNote: .absent)) { key, context in
      XCTAssertEqual(key.stringValue, "usageNote")
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertNil(context.underlyingError)
    }
  }

  func testInvalidTypeUsageNote() throws {
    let values: [Any] = [
      Int.random(in: Int.min...Int.max),
      [:],
      Float.random(in: 100.0..<1000.0),
      [],
    ]
    for value in values {
      typeMismatch(
        from: semanticTypeInfo(usageNote: .present(value)),
        completion: { dataType, context in
          XCTAssert(dataType is String.Type)
          XCTAssertFalse(context.codingPath.isEmpty)
          XCTAssertEqual(context.codingPath[0].stringValue, "usageNote")
          XCTAssertNil(context.underlyingError)
        })
    }
  }

  func testUnsupportedFormatName() throws {
    let strings = [
      "",
      .randomAlphaNumericString(of: 10),
      .randomBoolString(),
      .randomNumericString(of: 10),
    ]
    for string in strings {
      dataCorrupted(from: semanticTypeInfo(name: .present(string))) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "name")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testSupportedFormatName() throws {
    // Supported semantic types.
    let semanticTypeStrings = UMLSSemanticType.allCases.map { $0.rawValue }
    for semanticType in semanticTypeStrings {
      let result = try toObject(from: semanticTypeInfo(name: .present(semanticType))).name
      XCTAssertEqual(result, .semanticType(UMLSSemanticType(rawValue: semanticType)!))
    }
    // Supported semantic type relation labels.
    let relationLabels = UMLSSemanticTypeRelationLabel.allCases.map { $0.rawValue }
    for relationLabel in relationLabels {
      let result = try toObject(from: semanticTypeInfo(name: .present(relationLabel))).name
      XCTAssertEqual(result, .relation(UMLSSemanticTypeRelationLabel(rawValue: relationLabel)!))
    }
  }

  func testNullName() throws {
    valueNotFound(from: semanticTypeInfo(name: .present(nil))) { dataType, context in
      XCTAssert(dataType is String.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "name")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testMissingName() throws {
    keyNotFound(from: semanticTypeInfo(name: .absent)) { key, context in
      XCTAssertEqual(key.stringValue, "name")
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertNil(context.underlyingError)
    }
  }

  func testInvalidTypeName() throws {
    let values: [Any] = [
      Int.random(in: Int.min...Int.max),
      [:],
      [],
      Float.random(in: 100.0...1000.0),
    ]
    for value in values {
      typeMismatch(from: semanticTypeInfo(name: .present(value))) { dataType, context in
        XCTAssert(dataType is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "name")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testWholeNumberCount() throws {
    let number = UInt.random(in: 0..<UInt.max)
    let result = try toObject(from: semanticTypeInfo(count: .present(number))).count
    XCTAssertGreaterThanOrEqual(result, 0)
    XCTAssertEqual(result, number)
  }

  func testNegativeCount() throws {
    let number = Int.random(in: Int.min..<0)
    dataCorrupted(from: semanticTypeInfo(count: .present(number))) { context in
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertNotNil(context.underlyingError)
      let error = context.underlyingError! as NSError
      XCTAssertEqual(error.domain, NSCocoaErrorDomain)
      XCTAssertEqual(error.code, 3840)
      XCTAssertFalse(error.userInfo.isEmpty)
      XCTAssertEqual(error.userInfo.count, 1)
      XCTAssertNotNil(error.userInfo[NSDebugDescriptionErrorKey])
    }
  }

  func testMissingCount() throws {
    keyNotFound(from: semanticTypeInfo(count: .absent)) { key, context in
      XCTAssertEqual(key.stringValue, "childCount")
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertNil(context.underlyingError)
    }
  }

  func testNullCount() throws {
    valueNotFound(from: semanticTypeInfo(count: .present(nil))) { dataType, context in
      XCTAssert(dataType is UInt.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "childCount")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testInvalidTypeCount() throws {
    typeMismatch(
      from: semanticTypeInfo(count: .present([:])),
      completion: { dataType, context in
        XCTAssert(dataType is UInt.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "childCount")
        XCTAssertNil(context.underlyingError)
      })
  }

  func testNilGroup() throws {
    let nullGroups: [JSONValue<Any>] = [
      .absent, .present(nil),
    ]
    for group in nullGroups {
      let result = try toObject(from: semanticTypeInfo(group: group)).group
      XCTAssertNil(result)
    }
  }

  func testValidFormattedGroup() throws {
    let dictionary = JSONSerializationDictionary.semanticTypeGroupInfo()
    let result = try toObject(from: semanticTypeInfo(group: .present(dictionary))).group
    XCTAssertNotNil(result)
    XCTAssertEqual(result!.abbreviation, dictionary["abbreviation"] as! String)
    XCTAssertEqual(result!.name, dictionary["expandedForm"] as! String)
    XCTAssertEqual(result!.count, dictionary["semanticTypeCount"] as! UInt)
  }

  func testInvalidTypeGroup() throws {
    let values: [Any] = [
      String.randomAlphaNumericString(of: 10),
      [],
      Int.random(in: Int.min...Int.max),
      Float.random(in: 1.0..<10000.0),
    ]
    for value in values {
      typeMismatch(from: semanticTypeInfo(group: .present(value))) { dataType, context in
        XCTAssert(dataType is [String: Any].Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "semanticTypeGroup")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testNoRelations() throws {
    let result = try toObject(from: semanticTypeInfo(relations: .present([]))).relations
    XCTAssert(result.isEmpty)
  }

  func testOneRelations() throws {
    let dictionaries = [
      JSONSerializationDictionary.semanticTypeRelationInfo(
        type: .present(UMLSSemanticTypeRelationLabel.adjacentTo.rawValue),
        relation: .present(UMLSSemanticValue.semanticType(.activity).rawValue),
        flag: .present(UMLSSemanticTypeFlag.defined.rawValue)
      )
    ]
    let result = try toObject(from: semanticTypeInfo(relations: .present(dictionaries))).relations
    XCTAssertFalse(result.isEmpty)
    XCTAssertEqual(result.count, 1)

    let object = result[0]
    XCTAssertEqual(object.type, .adjacentTo)
    XCTAssertEqual(object.relation, .semanticType(.activity))
    XCTAssertEqual(object.flag, .defined)
  }

  func testMultipleRelations() throws {
    let dictionaries = (0..<10).map { _ in JSONSerializationDictionary.semanticTypeRelationInfo()
    }
    let result = try toObject(from: semanticTypeInfo(relations: .present(dictionaries))).relations
    XCTAssertFalse(result.isEmpty)
    XCTAssertEqual(result.count, 10)
  }

  func testNullRelations() throws {
    valueNotFound(from: semanticTypeInfo(relations: .present(nil))) { dataType, context in
      XCTAssert(dataType is [Any].Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "relations")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testMissingRelations() throws {
    keyNotFound(from: semanticTypeInfo(relations: .absent)) { key, context in
      XCTAssertEqual(key.stringValue, "relations")
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertNil(context.underlyingError)
    }
  }

  func testInvalidTypeRelations() throws {
    let values: [Any] = [
      String.randomBoolString(),
      String.randomConceptString(),
      String.randomAlphaNumericString(of: 10),
      Int.random(in: 0..<10),
      Float.random(in: 10.0..<100.0),
    ]
    for value in values {
      typeMismatch(from: semanticTypeInfo(relations: .present(value))) {
        dataType, context in
        XCTAssert(dataType is [Any].Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "relations")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testNoInverseRelations() throws {
    let result = try toObject(from: semanticTypeInfo(inverseRelations: .present([])))
      .inverseRelations
    XCTAssertTrue(result.isEmpty)
  }

  func testNullInverseRelations() throws {
    valueNotFound(
      from: semanticTypeInfo(inverseRelations: .present(nil)),
      completion: { dataType, context in
        XCTAssert(dataType is [Any].Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "inverseRelations")
        XCTAssertNil(context.underlyingError)
      })
  }

  func testMissingInverseRelations() throws {
    keyNotFound(from: semanticTypeInfo(inverseRelations: .absent)) { key, context in
      XCTAssertEqual(key.stringValue, "inverseRelations")
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertNil(context.underlyingError)
    }
  }

  func testInvalidInverseRelations() throws {
    let values: [Any] = [
      String.randomBoolString(),
      String.randomNumericString(of: 10),
      Int.random(in: Int.min...Int.max),
      Float.random(in: 10.0..<10000.0),
      String.randomAlphaNumericString(of: 10),
    ]
    for value in values {
      typeMismatch(from: semanticTypeInfo(inverseRelations: .present(value))) {
        dataType, context in
        XCTAssert(dataType is [Any].Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "inverseRelations")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testOneInverseRelations() throws {
    let dictionaries = [
      JSONSerializationDictionary
        .semanticTypeInverseRelationInfo(
          type: .present(UMLSSemanticTypeRelationLabel.contains.rawValue),
          relation: .present(UMLSSemanticValue.semanticType(.amphibian).rawValue),
          flag: .present(UMLSSemanticTypeFlag.dni.rawValue)
        )
    ]
    let result = try toObject(
      from: semanticTypeInfo(inverseRelations: .present(dictionaries))
    ).inverseRelations
    XCTAssertFalse(result.isEmpty)
    XCTAssertEqual(result[0].type, UMLSSemanticTypeRelationLabel.contains)
    XCTAssertEqual(result[0].relation, UMLSSemanticValue.semanticType(.amphibian))
    XCTAssertEqual(result[0].flag, .dni)
  }

  func testMoreThanOneInverseRelations() throws {
    let dictionaries = (0..<10).map { _ in
      JSONSerializationDictionary.semanticTypeInverseRelationInfo()
    }
    let result = try toObject(from: semanticTypeInfo(inverseRelations: .present(dictionaries)))
      .inverseRelations
    XCTAssertFalse(result.isEmpty)
    XCTAssertEqual(result.count, 10)
  }

  func testEmptyInheritedRelations() throws {
    let result = try toObject(from: semanticTypeInfo(inheritedRelations: .present([])))
      .inheritedRelations
    XCTAssertTrue(result.isEmpty)
  }

  func testNullInheritedRelations() throws {
    valueNotFound(from: semanticTypeInfo(inheritedRelations: .present(nil))) {
      dataType, context in
      XCTAssert(dataType is [Any].Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "inheritedRelations")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testInvalidTypeInheritedRelations() throws {
    let values: [Any] = [
      [:],
      String.randomBoolString(),
      String.randomNumericString(of: 10),
      String.randomAlphaNumericString(of: 10),
      Int.random(in: Int.min...Int.max),
      Float.random(in: 100.0...1000.0),
    ]
    for value in values {
      typeMismatch(from: semanticTypeInfo(inheritedRelations: .present(value))) {
        dataType, context in
        XCTAssert(dataType is [Any].Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "inheritedRelations")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testMissingInheritedRelations() throws {
    keyNotFound(from: semanticTypeInfo(inheritedRelations: .absent)) { key, context in
      XCTAssertEqual(key.stringValue, "inheritedRelations")
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertNil(context.underlyingError)
    }
  }

  func testOneInheritedRelations() throws {
    let dictionaries = [
      JSONSerializationDictionary.semanticTypeInheritedRelationInfo(
        type: .present(UMLSSemanticTypeRelationLabel.adjacentTo.rawValue),
        relation: .present(UMLSSemanticValue.semanticType(.ageGroup).rawValue))
    ]
    let list = try toObject(from: semanticTypeInfo(inheritedRelations: .present(dictionaries)))
      .inheritedRelations
    XCTAssertFalse(list.isEmpty)
    XCTAssertEqual(list.count, 1)
    let result = list[0]
    XCTAssertEqual(result.type, .adjacentTo)
    XCTAssertEqual(result.relation, .semanticType(.ageGroup))
  }

  func testManyInheritedRelations() throws {
    let dictionaries = (0..<10).map { _ in
      JSONSerializationDictionary.semanticTypeInheritedRelationInfo()
    }
    let list = try toObject(from: semanticTypeInfo(inheritedRelations: .present(dictionaries)))
      .inheritedRelations
    XCTAssertFalse(list.isEmpty)
    XCTAssertEqual(list.count, 10)
  }

  func testEmptyInverseInheritedRelations() throws {
    let result = try toObject(from: semanticTypeInfo(inverseInheritedRelations: .present([])))
      .inverseInheritedRelations
    XCTAssertTrue(result.isEmpty)
  }

  func testNullInverseInheritedRelations() throws {
    valueNotFound(from: semanticTypeInfo(inverseInheritedRelations: .present(nil))) {
      dataType, context in
      XCTAssert(dataType is [Any].Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "inverseInheritedRelations")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testMissingInverseInheritedRelations() throws {
    keyNotFound(from: semanticTypeInfo(inverseInheritedRelations: .absent)) { key, context in
      XCTAssertEqual(key.stringValue, "inverseInheritedRelations")
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertNil(context.underlyingError)
    }
  }

  func testTypeMismatchInverseInheritedRelations() throws {
    let values: [Any] = [
      [:],
      String.randomBoolString(),
      String.randomNumericString(of: 10),
      String.randomAlphaNumericString(of: 10),
      Int.random(in: Int.min...Int.max),
      Float.random(in: 100.0..<1000.0),
    ]
    for value in values {
      typeMismatch(from: semanticTypeInfo(inverseInheritedRelations: .present(value))) {
        dataType, context in
        XCTAssert(dataType is [Any].Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "inverseInheritedRelations")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testOneInverseInheritedRelations() throws {
    let dictionaries = [
      JSONSerializationDictionary.semanticTypeInverseInheritedRelationInfo(
        type: .present(UMLSSemanticTypeRelationLabel.branchOf.rawValue),
        relation: .present(UMLSSemanticValue.relation(.conceptuallyRelatedTo).rawValue))
    ]
    let list = try toObject(
      from: semanticTypeInfo(inverseInheritedRelations: .present(dictionaries))
    ).inverseInheritedRelations
    XCTAssertFalse(list.isEmpty)
    XCTAssertEqual(list.count, 1)
    let result = list[0]
    XCTAssertEqual(result.type, .branchOf)
    XCTAssertEqual(result.relation, .relation(.conceptuallyRelatedTo))
  }

}
