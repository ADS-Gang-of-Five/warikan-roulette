//
//  AddTatekaeView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct AddTatekaeView: View {
    @State private var tatekaeName = ""
    @State private var money = ""
    @State private var payer: String?

    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section {
                        TextField("例：カニ道楽のランチ", text: $tatekaeName)
                    } header: {
                        Text("立替の名目")
                    }
                    Section {
                        TextField("￥ 5000", text: $money)
                            .keyboardType(.numberPad) // TODO: 金額の入力に対して、このモディファイアが適切か調べる。
                    } header: {
                        Text("立替の金額")
                    }
                    Section {
                        Picker("立替人", selection: $payer) {
                            Text("未選択").tag(String?.none)
                            Text("Sako").tag(String?.some("Sako"))
                            Text("Seigetsu").tag(String?.some("Seigetsu"))
                            Text("Maki").tag(String?.some("Maki"))
                        }
                    }
                }
                VStack {
                    Spacer()
                    Button(action: {
                        // 立替追加の処理
                    },
                           label: {
                        Text("立替を追加")
                            .modifier(LongStyle(isButtonDisabled: Binding.constant(true)))
                    })
                }
                .padding(.bottom, 1)
            }
            .navigationTitle("立替の追加")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // sheetを閉じる処理
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                    //                    .disabled(isButtonDisabled)
                }
            }
        }
    }
}

#Preview {
    AddTatekaeView()
}
