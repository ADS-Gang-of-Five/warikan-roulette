//
//  SeisanResultView.swift
//  Roulette
//
//  Created by sako0602 on 2023/12/05.
//

import SwiftUI

struct SeisanResultView: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    @EnvironmentObject private var mainViewModel: MainViewModel

    var body: some View {
        List {
            // 立替セクション
            Section {
                switch mainViewModel.selectedGroupTatekaes {
                case .some(let tatekaes):
                    HStack {
                        ForEach(tatekaes) { tatekae in
                            Text(tatekae.name)
                        }
                    }
                    .padding(.top, 3)
                case .none:
                    Text("読み込みエラー")
                        .padding(.top, 3)
                }
            } header: {
                Text("立替一覧")
            }
            // アンラッキーメンバーセクション
            Section {
                if case .success = mainViewModel.selectedGroupSeisanResponse {
                    Text("なし")
                        .padding(.top, 3)
                } else {
                    Text("アンラッキーメンバー名をここに記載")
                }
            } header: {
                Text("アンラッキーメンバー")
            }
            // 合計金額セクション
            Section {
                if let tatekaes = mainViewModel.selectedGroupTatekaes {
                    let sum = tatekaes.reduce(0) { partialResult, tatekae in
                        partialResult + tatekae.money
                    }
                    Text("\(sum)円")
                        .padding(.top, 3)
                } else {
                    Text("???円")
                        .padding(.top, 3)
                }
            } header: {
                Text("合計金額")
            }
            // 精算結果セクション
            Section {
                switch mainViewModel.selectedGroupSeisanResponse {
                // アンラッキーメンバーあり
                case .needsUnluckyMember:
                    Text("アンラッキーメンバーがいる場合の記述")
                // アンラッキーメンバーなし & 精算なし
                case .success(let seisanDataList) where seisanDataList.isEmpty:
                    Text("精算なし")
                // アンラッキーメンバーなし & 精算あり
                case .success(let seisanDataList):
                    ForEach(seisanDataList.indices, id: \.self) { index in
                        let seisanData = seisanDataList[index]
                        Text("\(seisanData.debtor.name)が\(seisanData.creditor.name)に\(seisanData.money)円渡す")
                    }
                // その他
                case .none:
                    Text("Error")
                }
            } header: {
                Text("精算結果")
            }
        }
        .listStyle(.plain)
        .font(.title3)
        .padding(.top)
        Button("トップに戻る") {
            viewRouter.path.removeLast(viewRouter.path.count)
        }
        .padding(.top)
    }
}

#Preview {
    SeisanResultView()
        .environmentObject(ViewRouter())
        .environmentObject(MainViewModel())
}
