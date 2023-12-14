//
//  ArchivedGroupListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/14.
//

import SwiftUI

struct ArchivedSeisanResultView: View {
    var body: some View {
        List {
            Section {
                Text("朝食、昼食、夕食")
                    .padding(.top, 3)
            } header: {
                Text("立替一覧")
            }
            Section {
                Text("10,000円")
                    .padding(.top, 3)
            } header: {
                Text("合計金額")
            }
            Section {
                Text("Sako")
                    .padding(.top, 3)
            } header: {
                Text("アンラッキーメンバー")
            }
            Section {
                VStack(alignment: .leading) {
                    Text("SeigetsuがSakoに3,300円渡す")
                        .padding(.top, 3)
                    Text("MakiがSakoに3,300円渡す")
                        .padding(.top, 3)
                }
            } header: {
                Text("精算結果")
            }
        }
        .listStyle(.plain)
        .font(.title3)
    }
}

#Preview {
    ArchivedSeisanResultView()
}
