//
//  TransactionRecordListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct TatekaeListView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var isButtonDisabled = true
    @State private var isShowAddTatekaeView = false

    let sampleTatekaes = ["朝食", "昼食", "夕食"]

    var body: some View {
        ZStack {
            if !sampleTatekaes.isEmpty {
                // TatekaeListを表示
                TatekaeList(sampleTatekaes: sampleTatekaes)
            } else {
                Text("右下のボタンから立替を追加")
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
    }
}

private struct TatekaeList: View {
    let sampleTatekaes: [String]

    var body: some View {
        List {
            Section {
                ForEach(sampleTatekaes, id: \.self) { tatekae in
                    Button(action: {}, label: {
                        HStack {
                            Text(tatekae)
                                .font(.title2)
                            Spacer()
                            VStack {
                                Text("xxxx年xx月xx日")
                                Text("合計 xxxx円")
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
}
