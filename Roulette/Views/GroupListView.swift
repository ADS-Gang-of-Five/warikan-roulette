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
                        let path = ViewRouter.Path.tatekaeListView(
                            id: warikanGroup.id,
                            navigationTitle: warikanGroup.name
                        )
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
            .navigationDestination(for: ViewRouter.Path.self) { path in
                viewRouter.view(path)
            }
        }
        .environmentObject(viewRouter)
    }
}

#Preview {
    GroupListView()
}
