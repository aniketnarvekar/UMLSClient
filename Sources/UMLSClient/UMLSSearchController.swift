// Search.swift
// Establish UMLS search API.

import Foundation

/// A container to encapsulate UMLS version information.
public struct UMLSVersion: Equatable {

  /// UMLS version release.
  public enum Release: String {
    case AA
    case AB
  }

  /// Release year for the UMLS.
  public enum ReleaseYear: Int {
    case year2008 = 2008
    case year2009 = 2009
    case year2010 = 2010
    case year2011 = 2011
    case year2012 = 2012
    case year2013 = 2013
    case year2014 = 2014
    case year2015 = 2015
    case year2016 = 2016
    case year2017 = 2017
    case year2018 = 2018
    case year2019 = 2019
    case year2020 = 2020
    case year2021 = 2021
    case year2022 = 2022
    case year2023 = 2023
    case year2024 = 2024
  }

  /// The release year of the UMLS.
  public let year: ReleaseYear
  /// Release part of UMLS version.
  public let release: Release

  /// Initialise `UMLSVERSION` object.
  /// - Parameters:
  ///   - year: Year of release.
  ///   - release: Major and minor release.
  public init(year: ReleaseYear, release: Release) {
    self.year = year
    self.release = release
  }

  /// UMLS version string conversion error
  public enum VersionStringError: Error, Equatable {
    case invalidlength
    case invalidYear(string: String)
    case unsupportedYear(year: Int)
    case unsupportedRelease(release: String)
  }

  /// Initialize ``UMLSVersion`` using a string.
  ///
  /// The initializer will raise a “VersionStringError.invalidlength” error when `string` is not of length 6.
  /// The initializer will raise a `VersionStringError.invalidYear(string:)` error when the
  /// first 4 characters can't be converted to an integer. The initializer will raise
  /// `VersionStringError.unsupportedYear(year:)` on an unsupported year in a string.
  /// The initializer will raise `VersionStringError.unsupportedRelease(release:)` on an
  /// unsupported release part in a string.
  ///
  /// - Parameter string: A UMLS version string.
  /// - Throws: Raise ``VersionStringError`` on an ill formatted string.
  public init(string: String) throws {

    guard string.count == 6 else {
      throw VersionStringError.invalidlength
    }

    let yearString = String(string[..<String.Index(utf16Offset: 4, in: string)])
    guard
      let number = Int(yearString)
    else {
      throw VersionStringError.invalidYear(string: yearString)
    }

    guard
      let year = ReleaseYear(rawValue: number)
    else {
      throw VersionStringError.unsupportedYear(year: number)
    }

    let releaseString = String(
      string[
        String.Index(utf16Offset: 4, in: string)..<String.Index.init(utf16Offset: 6, in: string)
      ]
    )
    guard
      let release = Release(rawValue: releaseString)
    else {
      throw VersionStringError.unsupportedRelease(release: releaseString)
    }

    self.init(year: year, release: release)

  }

}

extension UMLSVersion: CustomStringConvertible {

  /// Returns string representation of ``UMLSVersion``.
  public var description: String {
    "\(year.rawValue)\(release.rawValue)"
  }

}

/// Decodes search error response.
public struct SearchErrorInfo: Decodable, Sendable {

  /// The name of the error
  public let code: String
  /// The explanation of respective `code`.
  public let message: String

  enum CodingKeys: String, CodingKey {
    case code = "name"
    case message
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<SearchErrorInfo.CodingKeys> = try decoder.container(
      keyedBy: SearchErrorInfo.CodingKeys.self)
    self.code = try container.decode(String.self, forKey: SearchErrorInfo.CodingKeys.code)
    self.message = try container.decode(String.self, forKey: SearchErrorInfo.CodingKeys.message)
  }

}

/// The possible search errors.
public enum SearchError: Error {
  // Describes the search is unauthorized.
  case unauthorized
  // Describes client error with error information.
  case searchError(info: SearchErrorInfo)
  // Other error which is not defined.
  case unknown
}

public protocol UMLSSearchController {

  func search(_ searchParameters: UMLSSearchParameters) async throws -> UMLSSearchPage

}
