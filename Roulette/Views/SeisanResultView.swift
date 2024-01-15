//
//  SeisanResultView.swift
//  Roulette
//
//  Created by sako0602 on 2023/12/05.
//

import SwiftUI

struct SeisanResultView: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    
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
}
