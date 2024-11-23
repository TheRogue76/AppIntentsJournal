/*
See LICENSE folder for this sample’s licensing information.

Abstract: An AppIntent that is performed when the user interacts with the Compose control (e.g. in Control Center).

*/

import AppIntents

struct ComposeControlAction: AppIntent {

    static let title: LocalizedStringResource = "Compose Journal Entry"

    static var isDiscoverable = false

    func perform() async throws -> some IntentResult & OpensIntent {
        
        // Code that performs the action...
        return .result(opensIntent: ComposeNewJournalEntry())
    }
}
