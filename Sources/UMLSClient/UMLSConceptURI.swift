import Foundation

enum UMLSConceptURI {
  case conceptInfo(for: UMLSUI<UMLSConcept>, version: UMLSVersion)
  case definitions(using: UMLSConceptDefinitionParameters, version: UMLSVersion)
  case relations(using: UMLSConceptRelationParameters, version: UMLSVersion)
  case atoms(using: UMLSConceptAtomParameters, version: UMLSVersion)
  case preferred(for: UMLSUI<UMLSConcept>, version: UMLSVersion)
  case semanticType(for: UMLSUI<UMLSTUI>, version: UMLSVersion)
  case sourceVocabulary(version: UMLSVersion)
}

extension UMLSConceptURI {

  func url(for baseURL: URL) -> URL {
    switch self {
    case .conceptInfo(let concept, let version):
      let path = "/content/\(version.description)/CUI/\(concept.description)"
      if #available(iOS 16.0, *) {
        return
          baseURL
          .appending(
            path: path
          )
      } else {
        return URL(string: path, relativeTo: baseURL)!
      }
    case .definitions(let parameter, let version):
      var queryItems: [URLQueryItem] = [
        .init(name: "pageSize", value: parameter.page.size.description),
        .init(name: "pageNumber", value: parameter.page.number.description),
      ]
      if !parameter.sourceVocabularies.isEmpty {
        queryItems
          .append(
            .init(
              name: "sabs",
              value: parameter.sourceVocabularies
                .map({ $0.rawValue })
                .joined(separator: ",")
            )
          )
      }
      let path = "/content/\(version.description)/CUI/\(parameter.concept.description)/definitions"

      if #available(iOS 16.0, *) {
        return
          baseURL
          .appending(path: path)
          .appending(queryItems: queryItems)
      } else {
        var component = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        component.path += path
        component.queryItems = queryItems
        return component.url!
      }
    case .relations(let parameters, let version):
      var queryItems: [URLQueryItem] = [
        .init(name: "includeObsolete", value: parameters.includeObsolete.description),
        .init(name: "includeSuppressible", value: parameters.includeSuppressible.description),
        .init(name: "pageNumber", value: parameters.page.number.description),
        .init(name: "pageSize", value: parameters.page.size.description),
      ]

      if !parameters.relationLabels.isEmpty {
        queryItems.append(
          .init(
            name: "includeRelationLabels",
            value: parameters.relationLabels
              .map({ $0.rawValue })
              .joined(separator: ",")))
      }

      if !parameters.additionalRelationLabels.isEmpty {
        queryItems.append(
          .init(
            name: "includeAdditionalRelationLabels",
            value: parameters.additionalRelationLabels
              .map({ $0.rawValue })
              .joined(separator: ",")))
      }

      if !parameters.sourceVocabularies.isEmpty {
        queryItems
          .append(
            .init(
              name: "sabs",
              value: parameters.sourceVocabularies
                .map({ $0.rawValue })
                .joined(separator: ",")
            )
          )
      }

      let path = "/content/\(version.description)/CUI/\(parameters.concept.description)/relations"
      if #available(iOS 16.0, *) {
        return
          baseURL
          .appending(path: path)
          .appending(queryItems: queryItems)
      } else {
        var component = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        component.path += path
        component.queryItems = queryItems
        return component.url!
      }
    case .atoms(let parameters, let version):
      var queryItems: [URLQueryItem] = [
        .init(name: "includeObsolete", value: parameters.includeObsolete.description),
        .init(name: "includeSuppressible", value: parameters.includeSuppressible.description),
        .init(name: "pageNumber", value: parameters.page.number.description),
        .init(name: "pageSize", value: parameters.page.size.description),
      ]

      if !parameters.sourceVocabularies.isEmpty {
        queryItems
          .append(
            .init(
              name: "sabs",
              value: parameters.sourceVocabularies
                .map({ $0.rawValue })
                .joined(separator: ",")
            )
          )
      }

      if !parameters.termTypes.isEmpty {
        queryItems.append(
          .init(
            name: "ttys",
            value: parameters.termTypes
              .map({ $0.rawValue })
              .joined(separator: ",")
          )
        )
      }

      if let lang = parameters.language {
        queryItems.append(.init(name: "language", value: lang.rawValue))
      }
      let path = "/content/\(version.description)/CUI/\(parameters.concept.description)/atoms"
      if #available(iOS 16.0, *) {
        return
          baseURL
          .appending(path: path)
          .appending(queryItems: queryItems)
      } else {
        var component = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        component.path += path
        component.queryItems = queryItems
        return component.url!
      }
    case .preferred(let concept, let version):
      let path = "/content/\(version.description)/CUI/\(concept.description)/atoms/preferred"
      if #available(iOS 16.0, *) {
        return
          baseURL
          .appending(path: path)
      } else {
        var component = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        component.path = path
        return component.url!
      }
    case .semanticType(for: let ui, let version):
      let path = "/semantic-network/\(version.description)/TUI/\(ui.description)"
      if #available(iOS 16.0, *) {
        return
          baseURL
          .appending(path: path)
      } else {
        var component = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        component.path = path
        return component.url!
      }
    case .sourceVocabulary(let version):
      let path = "/metadata/\(version.description)/sources"
      if #available(iOS 16.0, *) {
        return baseURL.appending(path: path)
      } else {
        var component = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        component.path = path
        return component.url!
      }
    }
  }

}
