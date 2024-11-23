/*
See LICENSE folder for this sample’s licensing information.

Abstract: Journaling intents conforming to the Journaling domain schema.

*/

import AppIntents
import CoreLocation
import SwiftData
import CoreSpotlight

enum IntentError: Error {
    case noEntity
}

@AssistantIntent(schema: .journal.createEntry)
struct CreateJournalEntryIntent {
    var message: AttributedString
    var title: String?
    var entryDate: Date?
    var location: CLPlacemark?
    
    @Parameter(default: [])
    var mediaItems: [IntentFile]
    
    @Parameter(title: "State of Mind")
    var mood: DeveloperStateOfMind?
    
    func perform() async throws -> some ReturnsValue<JournalEntryEntity> {
        do {
            let modelContext = ModelContext(DataModel.shared.modelContainer)
            let entry = JournalEntry(title: title, message: message, entryDate: entryDate, stateOfMind: mood)
            modelContext.insert(entry)
            try modelContext.save()

            try? await CSSearchableIndex.default().indexAppEntities([entry.entity])

            return .result(value: entry.entity)

        } catch {
            throw IntentError.noEntity
        }
    }
}

@AssistantIntent(schema: .journal.search)
struct SearchJournalEntriesIntent: ShowInAppSearchResultsIntent {
    static var searchScopes: [StringSearchScope] = [.general]
    
    var criteria: StringSearchCriteria
    @Dependency
    var navigation: NavigationManager
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let searchString = criteria.term
        // Code that navigates to your app's search and enters the search string into a search field.
        navigation.openSearch(with: searchString)
        return .result()
    }
}
