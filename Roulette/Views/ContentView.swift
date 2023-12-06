//
//  ContentView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/07.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            GroupListView()
                .tabItem { Label("割り勘グループ", systemImage: "person.3.fill") }
            ArchiveView()
                .tabItem { Label("清算済グループ", systemImage: "archivebox.fill") }
        }
    }
}

#Preview {
    ContentView()
}
