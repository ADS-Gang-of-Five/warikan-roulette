//
//  ViewRouter.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

enum Path: Hashable, Equatable {
    case tatekaeListView(id: EntityID<WarikanGroup>, navigationTitle: String)
    case confirmView(EntityID<WarikanGroup>)
    case rouletteView(EntityID<WarikanGroup>)
    case rouletteResultView(EntityID<ArchivedWarikanGroup>)
    case seisanResultView(EntityID<ArchivedWarikanGroup>)
}

final class ViewRouter: ObservableObject {
    @Published var path = NavigationPath()
}
