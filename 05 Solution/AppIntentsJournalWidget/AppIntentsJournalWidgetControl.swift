/*
See LICENSE folder for this sample’s licensing information.

Abstract: A control allowing users to quickly create a new journal entry.

*/

import AppIntents
import SwiftUI
import WidgetKit

struct AppIntentsJournalWidgetControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: "com.apple-evangelism.com.AppIntentsJournal.AppIntentsJournalWidget"
        ) {
            ControlWidgetButton(action: ComposeControlAction()) {
                Label("Create Entry", systemImage: "rectangle.and.pencil.and.ellipsis")

            }
        }
        .displayName("Compose")
        .description("A control that starts writing a new journal entry.")
    }
}
