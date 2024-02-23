//
//  TransactionRecordListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct TatekaeListView: View {
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
            if let tatekaes = viewModel.tatekaeDTOs, tatekaes.isEmpty == false {
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
                NavigationLink("清算", value: Path.confirmView(viewModel.warikanGroupID))
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
