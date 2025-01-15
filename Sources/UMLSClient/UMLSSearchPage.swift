// UMLSPage.swift

import Foundation

/// A search page.
public struct UMLSSearchPage: Decodable {

    /// The number of elements per page.
    public let size: Int
    /// The current page number.
    public let number: Int
    /// The total number of page available.
    public let count: Int
    /// The list of elements on current page.
    public let elements: [UMLSSearchElement]

    private enum CodingKeys: CodingKey {
        case result
        case results
        case pageSize
        case pageNumber
        case recCount
    }

    /// Initializes a new instance of `UMLSPage` by decoding from the given decoder.
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.size = try container.decode(Int.self, forKey: .pageSize)
        self.number = try container.decode(Int.self, forKey: .pageNumber)
        let resultContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
        self.elements = try resultContainer.decode([UMLSSearchElement].self, forKey: .results)
        let totalSize = try resultContainer.decode(Int.self, forKey: .recCount)
        var count = totalSize / size
        count += totalSize % size > 0 ? 1 : 0
        self.count = count
    }

}

public struct UMLSSearchElement: Decodable, Equatable {

    public let id: String
    public let source: String
    public let name: String

    private enum CodingKeys: String, CodingKey {
        case id = "ui"
        case source = "rootSource"
        case name
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.source = try container.decode(String.self, forKey: .source)
        self.name = try container.decode(String.self, forKey: .name)
    }

}
