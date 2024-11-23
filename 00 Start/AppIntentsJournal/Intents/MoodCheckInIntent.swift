//
//  Untitled.swift
//  AppIntentsJournal
//
//  Created by Parsa's Content Creation Corner on 2024-11-13.
//
import AppIntents
import SwiftData
import CoreSpotlight

struct MoodCheckInIntent: AppIntent {
    static var title: LocalizedStringResource = "Check in your mood"
    
    @Parameter(title: "Mood")
    var mood: DeveloperStateOfMind
    
    @MainActor
    func perform() async throws -> some ReturnsValue<JournalEntryEntity> & ProvidesDialog {

        let modelContext = ModelContext(DataModel.shared.modelContainer)
        let entry = JournalEntry(title: nil, message: nil, entryDate: nil, stateOfMind: mood)
        modelContext.insert(entry)
        Task {
            try? await CSSearchableIndex.default().indexAppEntities([entry.entity])
        }
        try modelContext.save()
        return .result(value: entry.entity, dialog: IntentDialog("Journal entry added"))
    }
}
