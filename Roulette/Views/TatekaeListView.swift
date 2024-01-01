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
    @State private var isButtonDisabled = true
    @State private var isShowAddTatekaeView = false

    var body: some View {
        ZStack {
            switch mainViewModel.selectedGroupTatekaes {
            case .none:
                Text("エラーが発生しました。前の画面に一度戻り再度お試しください。")
                    .padding(.horizontal)
            case .some(let tatekaes) where tatekaes.isEmpty:
                Text("右下のボタンから立替を追加")
                    .padding(.horizontal)
            case .some(let tatekaes):
                TatekaeList(tatekaes: tatekaes)
            }
            AddButton()
                .onTapGesture {
                    isShowAddTatekaeView = true
                }
        }
        .sheet(isPresented: $isShowAddTatekaeView) {
            AddTatekaeView()
            // .interactiveDismissDisabled() // FIXME: 一時的にコメントアウト
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("清算", value: Path.confirmView)
            }
        }
        .navigationTitle("groupName")
    }
}

private struct TatekaeList: View {
    let tatekaes: [Tatekae]

    var body: some View {
        List {
            Section {
                ForEach(tatekaes) { tatekae in
                    Button(action: {
                        // 詳細画面を表示する処理
                    }, label: {
                        HStack {
                            Text(tatekae.name)
                                .font(.title2)
                            Spacer()
                            VStack {
                                Text("xxxx年xx月xx日")
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
