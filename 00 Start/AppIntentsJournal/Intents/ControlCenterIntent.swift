//
//  ControlCenterIntent.swift
//  AppIntentsJournal
//
//  Created by Parsa's Content Creation Corner on 2024-11-13.
//

import AppIntents

struct ControlCenterIntent: AppIntent {
    static var title: LocalizedStringResource = "Just open the app"
    
    static var openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let store = UserDefaults.standard
        let currentVal = store.bool(forKey: "isOn")
        store.set(!currentVal, forKey: "isOn")
        return .result()
    }
}
