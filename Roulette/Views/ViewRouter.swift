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

    @ViewBuilder
    func view(_ path: Path) -> some View {
        switch path {
        case .tatekaeListView(let id, let navigationTitle):
            TatekaeListView(warikanGroupID: id)
                .navigationTitle(navigationTitle)
        case .confirmView(let id):
            ConfirmView(warikanGroupID: id)
                .navigationTitle("立て替えの確認")
                .navigationBarTitleDisplayMode(.inline)
        case .rouletteView(let id):
            RouletteView(warikanGroupID: id)
        case .rouletteResultView(let id):
            RouletteResultView(archivedWarikanGroupID: id)
        case .seisanResultView(let archivedWarikanGroupID):
            SeisanResultView(archivedWarikanGroupID: archivedWarikanGroupID)
                .navigationTitle("精算結果")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}
