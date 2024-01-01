//
//  GroupListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct GroupListView: View {
    @StateObject private var viewRouter = ViewRouter()
    @State private var isShowAddGroupListView = false
    @EnvironmentObject private var mainViewModel: MainViewModel
    
    var body: some View {
        NavigationStack(path: $viewRouter.path) {
            ZStack {
                if !mainViewModel.allGroups.isEmpty {
                    List {
                        ForEach(mainViewModel.allGroups) { group in
                            NavigationLink(group.name, value: Path.tatekaeListView)
                        }
                    }
                    .navigationDestination(for: Path.self) { path in
                        switch path {
                        case .tatekaeListView:
                            TatekaeListView()
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
        .environmentObject(mainViewModel)
        .sheet(isPresented: $isShowAddGroupListView) {
            AddGroupView()
                .interactiveDismissDisabled()
        }
        .task {
            await mainViewModel.getAllWarikanGroups()
        }
    }
}

#Preview {
    GroupListView()
}
