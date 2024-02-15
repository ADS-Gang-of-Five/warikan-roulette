//
//  GroupListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct GroupListView: View {
    @StateObject private var viewRouter = ViewRouter()
    @State private var isShowAddGroupView = false
    @EnvironmentObject private var mainViewModel: MainViewModel

    var body: some View {
        NavigationStack(path: $viewRouter.path) {
            VStack {
                if !mainViewModel.allGroups.isEmpty {
                    List(mainViewModel.allGroups) { group in
                            HStack {
                                Button(action: {
                                    Task {
                                        await mainViewModel.selectWarikanGroup(warikanGroup: group)
                                        viewRouter.path.append(Path.tatekaeListView)
                                    }
                                }, label: {
                                    Text(group.name)
                                        .foregroundStyle(.black)
                                })
                                Spacer()
                                Image(systemName: "chevron.forward")
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
                        case .seisanResultView(let id):
                            SeisanResultView(archivedWarikanGroupID: id)
                                .navigationTitle("精算結果")
                                .navigationBarTitleDisplayMode(.large)
                        }
                    }
                } else {
                    Text("割り勘グループを右下のボタンから追加してください")
                        .font(.title2)
                        .padding(.horizontal, 30)
                }
            }
            .task {
                await mainViewModel.getAllWarikanGroups()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottomTrailing) {
                AddButton {
                    isShowAddGroupView = true
                }
                .padding(.trailing)
            }
            .navigationTitle("割り勘グループ")
        }
        .environmentObject(viewRouter)
        .environmentObject(mainViewModel)
        .sheet(isPresented: $isShowAddGroupView,
               onDismiss: {
            Task {
                await mainViewModel.getAllWarikanGroups()
            }
        },
               content: {
            AddGroupView()
                .interactiveDismissDisabled()
        })
    }
}
