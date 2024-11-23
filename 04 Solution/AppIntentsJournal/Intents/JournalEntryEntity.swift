/*
See LICENSE folder for this sample’s licensing information.

Abstract: The Journal Entry entity, as an Assistant Entity conforming to a domain schema.

*/

import AppIntents
import CoreLocation
import SwiftData
import CoreSpotlight

@AssistantEntity(schema: .journal.entry)
struct JournalEntryEntity: IndexedEntity, Identifiable {
    static let defaultQuery = JournalQuery()
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(stringLiteral: title ?? "No Title")
    }
    let id: UUID
    
    var title: String?
    var message: AttributedString?
    var entryDate: Date?
    
    var mediaItems: [IntentFile]
    var location: CLPlacemark?
    var mood: DeveloperStateOfMind?
    
    init(item: JournalEntry) {
        id = item.journalID
        title = item.title
        entryDate = item.entryDate
        message = item.messageAsAttributedString
        mood = item.stateOfMind
    }
}

extension JournalEntryEntity {
    var attributeSet: CSSearchableItemAttributeSet {
        let attributeSet = defaultAttributeSet
        attributeSet.title = title
        if let message {
            attributeSet.contentDescription = String(message.characters[...])
        }
        return attributeSet
    }
}

struct JournalQuery: EntityQuery {
    
    @MainActor
    func entities(for identifiers: [JournalEntryEntity.ID]) async throws -> [JournalEntryEntity] {
        let modelContext = DataModel.shared.modelContainer.mainContext
        let journals = try modelContext.fetch(FetchDescriptor<JournalEntry>(predicate: #Predicate { identifiers.contains($0.journalID) }))
        return journals.map { JournalEntryEntity(item: $0) }
    }
    
    func suggestedEntities() async throws -> [JournalEntryEntity] {
        let modelContext = ModelContext(DataModel.shared.modelContainer)
        var descriptor = FetchDescriptor<JournalEntry>(predicate: #Predicate { _ in true})
        descriptor.fetchLimit = 8
        let journals = try modelContext.fetch(descriptor)
        return journals.map { JournalEntryEntity(item: $0) }
    }
}
