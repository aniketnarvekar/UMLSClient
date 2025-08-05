// UMLSLanguage.swift

import Foundation
import UMLSClientModel
import WebURL

// MARK: - SourceVocabularyController

public protocol UMLSSourceVocabularyController {
  func fetchAll() async throws -> UMLSPage<
    [UMLSSourceVocabularyTypeObject<
      UMLSSourceVocabularyInfo<
        UMLSLanguageTypeObject<UMLSLanguageInfo>, UMLSCreatorContact<UMLSPostalAddress>,
        UMLSLicenseContact<UMLSPostalAddress>
      >
    >]
  >
}
