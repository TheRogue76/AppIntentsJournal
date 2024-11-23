//
//  JournalEntryEntity.swift
//  AppIntentsJournal
//
//  Created by Parsa's Content Creation Corner on 2024-11-13.
//
import AppIntents
import CoreLocation
import SwiftData
import CoreSpotlight

@AssistantEntity(schema: .journal.entry)
struct JournalEntryEntity {
    struct JournalEntryEntityQuery: EntityStringQuery {
        func entities(for identifiers: [JournalEntryEntity.ID]) async throws -> [JournalEntryEntity] { [] }
        func entities(matching string: String) async throws -> [JournalEntryEntity] { [] }
    }
    
    static var defaultQuery = JournalEntryEntityQuery()
    var displayRepresentation: DisplayRepresentation { "Unimplemented" }
    
    let id: UUID
    
    var title: String?
    var message: AttributedString?
    var mediaItems: [IntentFile]
    var entryDate: Date?
    var location: CLPlacemark?
    var mood: DeveloperStateOfMind?
    
    init(_ item: JournalEntry) {
        id = item.journalID
        title = item.title
        entryDate = item.entryDate
        message = item.messageAsAttributedString
        mood = item.stateOfMind
    }
}

extension JournalEntryEntity: IndexedEntity {
    
    var attributeSet: CSSearchableItemAttributeSet {
        let defaultval = defaultAttributeSet
        defaultval.title = title
        if let message {
            defaultval.contentDescription = String(message.characters)
        }
        return defaultval
    }
}
