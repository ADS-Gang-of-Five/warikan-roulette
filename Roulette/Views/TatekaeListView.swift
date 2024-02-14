//
//  TransactionRecordListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct TatekaeListView: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    @EnvironmentObject private var mainViewModel: MainViewModel
    @State private var isShowAddTatekaeView = false
    @State private var focusedTatekaeForTatekaeDetailView: Tatekae?

    var body: some View {
        VStack {
            switch mainViewModel.selectedGroupTatekaes {
            case .none:
                Text("エラーが発生しました。前の画面に一度戻り再度お試しください。")
                    .padding(.horizontal)
            case .some(let tatekaes) where tatekaes.isEmpty:
                Text("右下のボタンから立替を追加")
                    .padding(.horizontal)
            case .some(let tatekaes):
                TatekaeList(tatekaes: tatekaes, focusedTatekae: $focusedTatekaeForTatekaeDetailView)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottomTrailing) {
            AddButton {
                isShowAddTatekaeView = true
            }
            .padding(.trailing)
        }
        .sheet(isPresented: $isShowAddTatekaeView,
               onDismiss: {
            mainViewModel.reloadTatekaeList()
        },
               content: {
            NavigationStack {
                AddTatekaeView(mainViewModel.selectedGroup!.id)
                    .interactiveDismissDisabled()
            }
        })
        .sheet(item: $focusedTatekaeForTatekaeDetailView) { tatekae in
            TatekaeDetailView(tatekae.id)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("清算", value: Path.confirmView)
                    // OneView-OneViewModelに切り替え時にViewModelにプロパティとして作成する。
                    .disabled({
                        return switch mainViewModel.selectedGroupTatekaes {
                        case .some(let tatekaes) where tatekaes.count >= 1:
                            false
                        default:
                            true
                        }
                    }())
            }
        }
        .navigationTitle(mainViewModel.selectedGroup?.name ?? "no Title")
    }
}

private struct TatekaeList: View {
    let tatekaes: [Tatekae]
    @Binding var focusedTatekae: Tatekae?

    var body: some View {
        List {
            Section {
                ForEach(tatekaes) { tatekae in
                    Button(action: {
                        focusedTatekae = tatekae
                    }, label: {
                        HStack {
                            Text(tatekae.name)
                                .font(.title2)
                            Spacer()
                            VStack {
                                Text(tatekae.createdTime.string)
                                Text("合計 \(tatekae.money)円")
                            }
                            .font(.footnote)
                        }
                        .padding(.vertical, 3)
                    })
                    .foregroundStyle(.primary)
                }
            } header: {
                Text("立替一覧")
            }
        }
    }
}

#Preview {
    TatekaeListView()
        .environmentObject(ViewRouter())
        .environmentObject(MainViewModel())
}

#warning("NavigationLinkのvalueを変更するのを忘れずに！")
struct NewTatekaeListView: View {
    @StateObject private var viewModel: TatekaeListViewModel
    @Environment(\.dismiss) private var dismiss

    init(warikanGroupID: EntityID<WarikanGroup>) {
        self._viewModel = StateObject(
            wrappedValue: TatekaeListViewModel(
                warikanGroupID: warikanGroupID
            )
        )
    }

    var body: some View {
        Group {
            if let tatekaes = viewModel.tatekaeDTOs {
                List {
                    Section {
                        ForEach(tatekaes) { tatekae in
                            Button(action: {
                                viewModel.focusedTatekaeDTO = tatekae
                            }, label: {
                                HStack {
                                    Text(tatekae.name)
                                        .font(.title2)
                                    Spacer()
                                    VStack {
                                        Text(tatekae.createdTime)
                                        Text("合計 \(tatekae.money)円")
                                    }
                                    .font(.footnote)
                                }
                                .padding(.vertical, 3)
                            })
                            .foregroundStyle(.primary)
                        }
                    } header: { Text("立替一覧") }
                }
            } else {
                Text("右下のボタンから立替を追加してください。")
            }
        }   
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottomTrailing) {
            AddButton { viewModel.isShowAddTatekaeView = true }
                .padding(.trailing)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("清算", value: Path.confirmView)
                    .disabled(viewModel.isNavigateToConfirmViewButtonDisabled)
            }
        }
        .task { await viewModel.makeTatekaeDTOs() }
        .sheet(
            isPresented: $viewModel.isShowAddTatekaeView,
            onDismiss: { Task { await viewModel.makeTatekaeDTOs() }},
            content: { AddTatekaeView(viewModel.warikanGroupID) }
        )
        .sheet(item: $viewModel.focusedTatekaeDTO) { tatekae in
            TatekaeDetailView(tatekae.id)
        }
        .alert(viewModel.alertText, isPresented: $viewModel.isShowAlert) {
            Button("戻る") { dismiss() }
        }
    }
}
