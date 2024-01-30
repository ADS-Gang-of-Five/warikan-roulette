//
//  ArchivedGroupListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/14.
//

import SwiftUI

struct ArchivedSeisanResultView: View {
    @StateObject private var viewModel: ArchivedSeisanResultViewModel

    init(archivedWarikanGroupData: ArchivedWarikanGroupData) {
        self._viewModel = StateObject(
            wrappedValue: ArchivedSeisanResultViewModel(
                archivedWarikanGroupData: archivedWarikanGroupData
            )
        )
    }

    var body: some View {
        VStack {
            if let viewData = viewModel.viewData {
                List {
                    Section {
                        ForEach(viewData.tatekaeList.indices, id: \.self) { i in
                            Text(viewData.tatekaeList[i])
                                .padding(.top, 3)
                        }
                    } header: {
                        Text("立替一覧")
                    }
                    Section {
                        Text("\(viewData.totalAmount)円")
                            .padding(.top, 3)
                    } header: {
                        Text("合計金額")
                    }
                    Section {
                        Text(
                            viewData.unluckeyMember != nil ?
                            viewData.unluckeyMember! : "なし"
                        )
                        .padding(.top, 3)
                    } header: {
                        Text("アンラッキーメンバー")
                    }
                    Section {
                        VStack(alignment: .leading) {
                            ForEach(viewData.seisanList.indices, id: \.self) { i in
                                let seisanData = viewData.seisanList[i]
                                Text("\(seisanData.debtor)が\(seisanData.creditor)に\(seisanData.money)円渡す。")
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
            await viewModel.getGroupData()
        }
    }
}
