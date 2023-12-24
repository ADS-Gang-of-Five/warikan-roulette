//
//  ViewRouter.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

enum Path: Hashable {
    case tatekaeListView(_ groupName: String, _ id: EntityID<WarikanGroup>)
    case confirmView
    case rouletteView
    case rouletteResultView
    case seisanResultView
}

final class ViewRouter: ObservableObject {
    @Published var path = NavigationPath()
}
