//
//  AddTatekaeView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct AddTatekaeView: View {
    @EnvironmentObject private var mainViewModel: MainViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var tatekaeName = ""
    @State private var money = ""
    @State private var payer: EntityID<Member>?

    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section {
                        TextField("例：イタリアンレストランでのランチ", text: $tatekaeName)
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
                            Text("未選択").tag(EntityID<Member>?.none)
                            if let members = mainViewModel.selectedGroupMembers {
                                ForEach(members) { member in
                                    Text(member.name)
                                        .tag(EntityID<Member>?.some(member.id))
                                }
                            }
                        }
                    }
                }
                VStack {
                    Spacer()
                    Button(action: {
                        Task {
                            guard let warikanGroupID: EntityID<WarikanGroup> = mainViewModel.selectedGroup?.id,
                                  tatekaeName.isEmpty == false,
                                  let payerID = payer,
                                  let recipantIDs = mainViewModel.selectedGroup?.members,
                                  let money = Int(self.money)
                            else { return }

                            await mainViewModel.appendTatekae(
                                warikanGroupID: warikanGroupID,
                                tatekaeName: tatekaeName,
                                payerID: payerID,
                                recipantIDs: recipantIDs,
                                money: money
                            )
                            dismiss()
                        }
                    },
                           label: {
                        Text("立替を追加")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                            .padding(.horizontal)
                            .padding(.horizontal)
                    })
                    .disabled(
                        tatekaeName.isEmpty || money.isEmpty || payer == nil
                    )
                }
                .padding(.bottom, 1)
            }
            .navigationTitle("立替の追加")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                }
            }
        }
    }
}

#Preview {
    AddTatekaeView()
        .environmentObject(MainViewModel())
}
