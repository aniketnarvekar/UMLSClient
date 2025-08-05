// Search.swift
// Establish UMLS search API.

import Foundation
import UMLSClientModel

public protocol UMLSSearchController {

  func search(_ searchParameters: UMLSSearchParameters) async throws -> UMLSSearchPage

}
