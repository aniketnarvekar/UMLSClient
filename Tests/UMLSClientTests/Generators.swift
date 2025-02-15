// Generators.swift

import UMLSClient
import Foundation

extension UMLSTermType {

    static func random(using generator: inout RandomNumberGenerator) -> UMLSTermType {
        UMLSTermType.allCases.randomElement(using: &generator)!
    }

    static func random() -> UMLSTermType {
        var g: any RandomNumberGenerator = SystemRandomNumberGenerator()
        return random(using: &g)
    }

}

extension UMLSLanguage {

    static func random(using generator: inout RandomNumberGenerator) -> UMLSLanguage {
        UMLSLanguage.allCases.randomElement(using: &generator)!
    }

    static func random() -> UMLSLanguage {
        var g: any RandomNumberGenerator = SystemRandomNumberGenerator()
        return random(using: &g)
    }

}

extension UMLSRelationLabel {

    static func random<G: RandomNumberGenerator>(using generator: inout G) ->  UMLSRelationLabel {
        UMLSRelationLabel.allCases.randomElement(using: &generator)!
    }

    static func random() -> UMLSRelationLabel {
        var g = SystemRandomNumberGenerator()
        return random(using: &g)
    }

}

extension UMLSAdditionalRelationLabel {

    public static func random<G: RandomNumberGenerator>(using generator: inout G) -> UMLSAdditionalRelationLabel {
        .allCases.randomElement(using: &generator)!
    }

    public static func random() -> UMLSAdditionalRelationLabel {
        var g = SystemRandomNumberGenerator()
        return random(using: &g)
    }

}

extension UInt8 {

    static let alphaNumericCharacterCodes: [UInt8] = [
        65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57
    ]

    static let numericCharacterCodes: [UInt8] = [
        48, 49, 50, 51, 52, 53, 54, 55, 56, 57
    ]

}

extension String {

    static func randomBoolString() -> String {
        ["true", "false"].randomElement()!
    }

    static func randomAlphaNumericString(of size: UInt) -> String {
        let array = (0..<size).map({ _ in Character(.init(UInt8.alphaNumericCharacterCodes.randomElement()!)) })
        return String(array)
    }

    static func randomNumericString(of size: UInt8) -> String {
        let array = (0...size).map({ _ in Character(.init(UInt8.numericCharacterCodes.randomElement()!)) })
        return String(array)
    }

}

extension Date {

    static func randomBetween(start: String, end: String, format: String = "MM-dd-yyyy") -> String {
        let date1 = Date.parse(start, format: format)
        let date2 = Date.parse(end, format: format)
        return Date.randomBetween(start: date1, end: date2).dateString(format)
    }

    static func randomBetween(start: Date, end: Date) -> Date {
        var date1 = start
        var date2 = end
        if date2 < date1 {
            let temp = date1
            date1 = date2
            date2 = temp
        }
        let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: span)
    }

    func dateString(_ format: String = "MM-dd-yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    static func parse(_ string: String, format: String = "MM-dd-yyyy") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = format

        let date = dateFormatter.date(from: string)!
        return date
    }

    static func randomDateString(format: String = "MM-dd-yyy") -> String {
        randomDate().dateString(format)
    }

    static func randomDate() -> Date {
        randomBetween(start: .distantPast, end: .now)
    }

}

extension UMLSUI where U == UMLSConcept {

    static func random<G: RandomNumberGenerator>(using generator: inout G) -> UMLSUI<U> {
        try! .init(string: "C\(Int.random(in: 1000000...9999999))")
    }

    static func random() -> UMLSUI<U> {
        var g = SystemRandomNumberGenerator()
        return random(using: &g)
    }

}

extension UMLSSourceVocabulary {

    static func random<G: RandomNumberGenerator>(using generator: inout G) -> UMLSSourceVocabulary {
        .allCases.randomElement(using: &generator)!
    }

    static func random() -> UMLSSourceVocabulary {
        var g = SystemRandomNumberGenerator()
        return random(using: &g)
    }

}
