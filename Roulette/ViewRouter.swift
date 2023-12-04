//
//  ViewRouter.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

enum Path {
    case tatekaeListView
}

final class ViewRouter: ObservableObject {
    @Published var path = NavigationPath()
}
