import UMLSClientModel

// MARK: - SemanticTypeController

public protocol UMLSSemanticTypeController {

  func info(of ui: UMLSUI<UMLSTUI>) async throws -> UMLSPage<UMLSSemanticTypeInfo>

}
