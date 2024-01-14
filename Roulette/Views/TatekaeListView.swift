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
        .sheet(isPresented: $isShowAddTatekaeView) {
            AddTatekaeView()
                .interactiveDismissDisabled()
        }
        .sheet(item: $focusedTatekaeForTatekaeDetailView) { tatekae in
            TatekaeDetailView(tatekae: tatekae)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("清算", value: Path.confirmView)
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
