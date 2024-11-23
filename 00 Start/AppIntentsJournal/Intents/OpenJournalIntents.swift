//
//  OpenJournalIntents.swift
//  AppIntentsJournal
//
//  Created by Parsa's Content Creation Corner on 2024-11-13.
//
import AppIntents
import SwiftData

struct OpenJournalIntents: AppIntent, OpenIntent {
    static var title: LocalizedStringResource = "Open Journal Entry"
    
    static var description = IntentDescription("Open a journal entry")
    
    @Parameter(title: "Journal Entry")
    var target: JournalEntryEntity
    
    @Dependency
    private var navigationManager: NavigationManager
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let modelContext = DataModel.shared.modelContainer.mainContext
        let entityId = target.id
        
        let journals = try modelContext.fetch(FetchDescriptor<JournalEntry>(predicate: #Predicate{ entry in
            entry.journalID == entityId
        }))
        if let journal = journals.first {
            navigationManager.openJournalEntry(journal)
        }
        return .result()
    }
}
