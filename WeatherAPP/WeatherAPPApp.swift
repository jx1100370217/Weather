//
//  WeatherAPPApp.swift
//  WeatherAPP
//
//  Created by 简雄 on 2026/1/17.
//

import SwiftUI
import CoreData

@main
struct WeatherAPPApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
