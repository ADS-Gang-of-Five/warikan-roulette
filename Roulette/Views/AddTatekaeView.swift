//
//  AddTatekaeView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct AddTatekaeView: View {
    @Binding var isShowAddTatekaeView: Bool
    @State var tatekaeTitle = ""
    @State private var tatekaeKingaku = ""
    @State var unluckeyMember = "未選択"
    
    var body: some View {
        NavigationStack{
            ZStack{
                Form {
                    Section {
                        TextField("例：カニ道楽のランチ", text: $tatekaeTitle)
                    } header: {
                        Text("立替の名目")
                    }
                    Section {
                        TextField("￥ 5000", text: $tatekaeKingaku)
                            .keyboardType(.numberPad) // TODO: 金額の入力に対して、このモディファイアが適切か調べる。
                    } header: {
                        Text("立替の金額")
                    }
                    Section {
                        Picker("立替人", selection: $unluckeyMember) {
                            Text("未選択").tag("未選択")
                            Text("Sako").tag("sako")
                            Text("Seigetsu").tag("seigetsu")
                            Text("Maki").tag("maki")
                        }
                    }
                }
                VStack {
                    Spacer()
                    Button(action: {
                        isShowAddTatekaeView = false
                    }, label: {
                        Text("立替を追加")
                            .modifier(LongStyle())
                    })
                }
                .padding(.bottom, 1)
            }
            .navigationTitle("立替の追加")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isShowAddTatekaeView = false
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                }
            }

        }
    }
}

#Preview {
    AddTatekaeView(isShowAddTatekaeView: Binding.constant(true))
}
