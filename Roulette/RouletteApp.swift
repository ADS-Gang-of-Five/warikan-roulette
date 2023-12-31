//
//  RouletteApp.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/07.
//

import SwiftUI

@main
struct RouletteApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(MainViewModel())
        }
    }
}
