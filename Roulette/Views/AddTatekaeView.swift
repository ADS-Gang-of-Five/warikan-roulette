//
//  AddTatekaeView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct AddTatekaeView: View {
    @ObservedObject var viewModel: TatekaeListViewModel
    @Binding var isShowAddTatekaeView: Bool
    @Binding var isButtonDisabled: Bool
    @State private var tatekaeName = ""
    @State private var money = ""
    @State private var payer: Member?
    let group: WarikanGroup
    
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
                            Text("未選択").tag(Member?.none)
                            ForEach(viewModel.members) { member in
                                Text(member.name).tag(Member?.some(member))
                            }
                        }
                    }
                }
                VStack {
                    Spacer()
                    Button(action: {
                        Task {
                            await viewModel.appendTatekae(
                                warikanGroupID: group.id,
                                tatekaeName: tatekaeName,
                                payerID: payer!.id,
                                recipantIDs: group.members,
                                money: 5000
                            )
                            isShowAddTatekaeView = false
                        }
                    },
                           label: {
                        Text("立替を追加")
                            .modifier(LongStyle(isButtonDisabled: $isButtonDisabled))
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
//                    .disabled(isButtonDisabled)
                }
            }
        }
    }
}

// swiftlint:disable comment_spacing
//#Preview {
//    AddTatekaeView(isShowAddTatekaeView: Binding.constant(true), members: [Member])
//}
// swiftlint:enable comment_spacing
// #Preview {
//     AddTatekaeView(isShowAddTatekaeView: Binding.constant(true))
// }
