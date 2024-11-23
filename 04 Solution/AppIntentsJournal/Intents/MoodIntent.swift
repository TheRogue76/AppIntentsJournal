/*
See LICENSE folder for this sample’s licensing information.

Abstract: A custom intent that allows the user to check in with their mood, provided as a parameter.

*/

import AppIntents
import SwiftData
import CoreSpotlight

struct MoodIntent: AppIntent {

    static var title: LocalizedStringResource = "Mood Check-In"
    static var description = IntentDescription("Adds a mood entry to the journal.")

    @Parameter(title: "State of Mind")
    var mood: DeveloperStateOfMind
    
    func perform() async throws -> some ProvidesDialog & ReturnsValue<JournalEntryEntity> {
        do {
            
            let modelContext = ModelContext(DataModel.shared.modelContainer)
            let entry = JournalEntry(stateOfMind: mood)
            modelContext.insert(entry)
            try modelContext.save()

            try? await CSSearchableIndex.default().indexAppEntities([entry.entity])

            let dialog = IntentDialog(full: "I created a new journal entry for you.",
                                      supporting: "Done.")
            return .result(value: entry.entity, dialog: dialog)
        } catch {
            throw IntentError.noEntity
        }
    }
    
}
