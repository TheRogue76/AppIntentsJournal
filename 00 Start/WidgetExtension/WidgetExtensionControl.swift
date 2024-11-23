//
//  WidgetExtensionControl.swift
//  WidgetExtension
//
//  Created by Parsa's Content Creation Corner on 2024-11-13.
//

import AppIntents
import SwiftUI
import WidgetKit

struct WidgetExtensionControl: ControlWidget {
    static let kind: String = "com.apple-evangelism.com.AppIntentsJournal.WidgetExtension"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: ControlCenterIntent()) {
                Label(isOnLabelText, systemImage: isOn ? "poweron" : "poweroff")
            }
        }
        
        var isOn: Bool {
            return UserDefaults.standard.bool(forKey: "isOn")
        }
        
        var isOnLabelText: String {
            isOn ? "On" : "Off"
        }
    }
}

extension WidgetExtensionControl {
    struct Value {
        var isRunning: Bool
        var name: String
    }

    struct Provider: AppIntentControlValueProvider {
        func previewValue(configuration: TimerConfiguration) -> Value {
            WidgetExtensionControl.Value(isRunning: false, name: configuration.timerName)
        }

        func currentValue(configuration: TimerConfiguration) async throws -> Value {
            let isRunning = true // Check if the timer is running
            return WidgetExtensionControl.Value(isRunning: isRunning, name: configuration.timerName)
        }
    }
}

struct TimerConfiguration: ControlConfigurationIntent {
    static let title: LocalizedStringResource = "Timer Name Configuration"

    @Parameter(title: "Timer Name", default: "Timer")
    var timerName: String
}

struct StartTimerIntent: SetValueIntent {
    static let title: LocalizedStringResource = "Start a timer"

    @Parameter(title: "Timer Name")
    var name: String

    @Parameter(title: "Timer is running")
    var value: Bool

    init() {}

    init(_ name: String) {
        self.name = name
    }

    func perform() async throws -> some IntentResult {
        // Start the timer…
        return .result()
    }
}
