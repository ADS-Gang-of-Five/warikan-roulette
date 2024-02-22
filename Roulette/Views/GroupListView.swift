//
//  GroupListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct GroupListView: View {
    @StateObject private var viewModel = GroupListViewModel()
    @StateObject private var viewRouter = ViewRouter()

    var body: some View {
        NavigationStack(path: $viewRouter.path) {
            Group {
                if let warikanGroups = viewModel.warikanGroups {
                    List(warikanGroups) { warikanGroup in
                        let path = Path.tatekaeListView(id: warikanGroup.id, navigationTitle: warikanGroup.name)
                        NavigationLink(warikanGroup.name, value: path)
                            .swipeActions(allowsFullSwipe: false) {
                                Button("Delete", systemImage: "trash.fill", role: .destructive) {
                                    viewModel.didTappedGroupDeleteButtonAction(id: warikanGroup.id)
                                }.tint(.red)
                            }
                    }
                    .disabled(viewModel.isNavigationLinkListDisabled)
                    .overlay {
                        if warikanGroups.isEmpty {
                            Text("割り勘グループを右下のボタンから追加してください。")
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("割り勘グループ")
            .task { await viewModel.fetchAllWarikanGroups() }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottomTrailing) {
                AddButton { viewModel.isShowAddGroupView = true }
                    .disabled(viewModel.isAddButtonDisabled)
                    .padding(.trailing)
            }
            .sheet(
                isPresented: $viewModel.isShowAddGroupView,
                onDismiss: { Task { await viewModel.fetchAllWarikanGroups() }},
                content: { AddGroupView().interactiveDismissDisabled() }
            )    
            .navigationDestination(for: Path.self) { path in
                switch path {
                case .tatekaeListView(let id, let navigationTitle):
                    TatekaeListView(warikanGroupID: id)
                        .navigationTitle(navigationTitle)
                case .confirmView:
                    ConfirmView()
                        .navigationTitle("立て替えの確認")
                        .navigationBarTitleDisplayMode(.inline)
                case .rouletteView:
                    RouletteView()
                case .rouletteResultView(let id):
                    RouletteResultView(archivedWarikanGroupID: id)
                case .seisanResultView(let archivedWarikanGroupID):
                    SeisanResultView(archivedWarikanGroupID: archivedWarikanGroupID)
                        .navigationTitle("精算結果")
                        .navigationBarTitleDisplayMode(.large)
                }
            }
        }
        .environmentObject(viewRouter)
    }
}

#Preview {
    GroupListView()
}
