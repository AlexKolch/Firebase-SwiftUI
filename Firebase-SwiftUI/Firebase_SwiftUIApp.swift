//
//  Firebase_SwiftUIApp.swift
//  Firebase-SwiftUI
//
//  Created by Алексей Колыченков on 04.10.2023.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct Firebase_SwiftUIApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
