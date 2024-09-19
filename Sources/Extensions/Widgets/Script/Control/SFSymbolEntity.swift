import AppIntents
import Foundation
import SFSafeSymbols

@available(iOS 16.4, macOS 13.0, watchOS 9.0, *)
struct SFSymbolEntity: AppEntity {
    static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "Icon")

    static let defaultQuery = IntentSFSymbolAppEntityQuery()

    var id: String
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(id)", image: .init(systemName: id))
    }
}

@available(iOS 16.4, macOS 13.0, watchOS 9.0, *)
struct IntentSFSymbolAppEntityQuery: EntityQuery, EntityStringQuery {
    func entities(for identifiers: [String]) async throws -> [SFSymbolEntity] {
        if identifiers.isEmpty {
            return symbols()
        } else {
            return symbols().filter { identifiers.contains($0.id) }
        }
    }

    func entities(matching string: String) async throws -> IntentItemCollection<SFSymbolEntity> {
        let matchingSymbols = symbols().filter { $0.id.contains(string.lowercased()) }
        return .init(items: matchingSymbols)
    }

    func suggestedEntities() async throws -> IntentItemCollection<SFSymbolEntity> {
        .init(items: symbols())
    }

    private func symbols() -> [SFSymbolEntity] {
        SFSymbol.allSymbols.map(\.rawValue).sorted().map({ SFSymbolEntity(id: $0) })
    }
}