//
//  ViewRouter.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

enum Path: Hashable, Equatable {
    case tatekaeListView
    case confirmView
    case rouletteView
    case rouletteResultView
    case seisanResultView(EntityID<ArchivedWarikanGroup>)
}

final class ViewRouter: ObservableObject {
    @Published var path = NavigationPath()
}
