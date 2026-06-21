//
//  irl_timeApp.swift
//  irl-time
//
//  Created by Nechal Maggon on 20/06/26.
//

import SwiftUI

@main
struct irl_timeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        MenuBarExtra {
            Button("Open IRL Time") {
                NSApp.activate(ignoringOtherApps: true)
            }
            Divider()
            Button("Quit") {
                NSApp.terminate(nil)
            }
        } label: {
            Image("MenuBarIcon")
        }
    }
}
