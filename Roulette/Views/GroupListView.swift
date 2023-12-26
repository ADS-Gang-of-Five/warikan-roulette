//
//  GroupListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct GroupListView: View {
    @StateObject private var viewRouter = ViewRouter()
    @StateObject private var groupListViewModel = GroupListViewModel()
    @State private var isShowAddGroupListView = false
    
    var body: some View {
        NavigationStack(path: $viewRouter.path) {
            ZStack {
                if !groupListViewModel.groups.isEmpty {
                        List {
                            ForEach(groupListViewModel.groups) { group in
                                NavigationLink(group.name, value: Path.tatekaeListView(group))
                            }
                        }
                        .navigationDestination(for: Path.self) { path in
                            switch path {
                            case .tatekaeListView(let group):
                                TatekaeListView(warikanGroup: group)
                                    .navigationTitle(group.name)
                            case .confirmView:
                                ConfirmView()
                                    .navigationTitle("立て替えの確認")
                                    .navigationBarTitleDisplayMode(.inline)
                            case .rouletteView:
                                RouletteView()
                            case .rouletteResultView:
                                RouletteResultView()
                            case .seisanResultView:
                                SeisanResultView()
                                    .navigationTitle("精算結果")
                                    .navigationBarTitleDisplayMode(.large)
                            }
                        }
                } else {
                    Text("割り勘グループを右下のボタンから追加してください")
                        .font(.title2)
                        .padding(.horizontal, 30)
                }
                AddButton()
                    .onTapGesture {
                        isShowAddGroupListView = true
                    }
            }
            .navigationTitle("割り勘グループ")
        }
        .environmentObject(viewRouter)
        .sheet(isPresented: $isShowAddGroupListView) {
            AddGroupView(
                isShowAddGroupListView: $isShowAddGroupListView) { groupName, groupListMemeber in
                    await groupListViewModel.createWarikanGroup(
                        name: groupName,
                        memberNames: groupListMemeber
                    )
                }
                .interactiveDismissDisabled()
        }
        .task {
            await groupListViewModel.fecthAllGroups()
        }
    }
}

#Preview {
    GroupListView()
}
