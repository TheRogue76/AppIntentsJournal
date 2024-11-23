//
//  JournalIntents.swift
//  AppIntentsJournal
//
//  Created by Parsa's Content Creation Corner on 2024-11-13.
//
import AppIntents
import CoreLocation
import SwiftData
import SwiftUI
import CoreSpotlight

@AssistantIntent(schema: .journal.createEntry)
struct CreateJournalEntryIntent {
    var message: AttributedString
    var title: String?
    var entryDate: Date?
    var location: CLPlacemark?
    
    @Parameter(default: [])
    var mediaItems: [IntentFile]
    
    @Parameter(title: "State of mind")
    var mood: DeveloperStateOfMind?
    
    func perform() async throws -> some ReturnsValue<JournalEntryEntity> {
        
        let modelContext = ModelContext(DataModel.shared.modelContainer)
        let entry = JournalEntry(title: title, message: message, entryDate: entryDate, stateOfMind: mood)
        modelContext.insert(entry)
        Task {
            try? await CSSearchableIndex.default().indexAppEntities([entry.entity])
        }
        try modelContext.save()
        return .result(value: entry.entity)
    }
}

@AssistantIntent(schema: .journal.search)
struct SearchJournalEntriesIntent: ShowInAppSearchResultsIntent {
    @Dependency var navigationManager: NavigationManager
    
    static var searchScopes: [StringSearchScope] = [.general]
    
    var criteria: StringSearchCriteria
    
    static var openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        navigationManager.openSearch(with: criteria.term)
        
        return .result()
    }
}
