//
//  ArchivedGroupListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/14.
//

import SwiftUI

struct ArchivedSeisanResultView: View {
    @StateObject private var viewModel: ArchivedSeisanResultViewModel
    @Environment(\.dismiss) private var dismiss

    init(archivedWarikanGroupID: EntityID<ArchivedWarikanGroup>) {
        self._viewModel = StateObject(
            wrappedValue: ArchivedSeisanResultViewModel(
                archivedWarikanGroupID: archivedWarikanGroupID
            )
        )
    }

    var body: some View {
        VStack {
            if let archivedWarikanGroup = viewModel.archivedWarikanGroupDTO {
                List {
                    Section {
                        ForEach(archivedWarikanGroup.tatekaeList.indices, id: \.self) { i in
                            Text(archivedWarikanGroup.tatekaeList[i])
                                .padding(.top, 3)
                        }
                    } header: {
                        Text("立替一覧")
                    }
                    Section {
                        Text("\(archivedWarikanGroup.totalAmount)円")
                            .padding(.top, 3)
                    } header: {
                        Text("合計金額")
                    }
                    Section {
                        Text(
                            archivedWarikanGroup.unluckyMember != nil ?
                            archivedWarikanGroup.unluckyMember! : "なし"
                        )
                        .padding(.top, 3)
                    } header: {
                        Text("アンラッキーメンバー")
                    }
                    Section {
                        if archivedWarikanGroup.seisanList.isEmpty {
                            Text("なし")
                        } else {
                            VStack(alignment: .leading) {
                                ForEach(archivedWarikanGroup.seisanList.indices, id: \.self) { i in
                                    let seisanData = archivedWarikanGroup.seisanList[i]
                                    Text("\(seisanData.debtor)が\(seisanData.creditor)に\(seisanData.money)円渡す。")
                                }
                            }
                        }
                    } header: {
                        Text("精算結果")
                    }
                }
                .listStyle(.plain)
            } else {
                Text("データの読み込みに失敗しました。")
            }
        }
        .font(.title3)
        .task {
            await viewModel.makeArchivedWarikanGroupDTO()
        }
        .alert(viewModel.alertText, isPresented: $viewModel.isShowAlert) {
            Button("戻る") { dismiss() }
        }
    }
}
