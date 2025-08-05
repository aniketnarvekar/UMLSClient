//  UMLSConceptController.swift

import Foundation
import UMLSClientModel

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
