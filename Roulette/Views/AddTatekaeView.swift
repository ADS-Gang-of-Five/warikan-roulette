//
//  AddTatekaeView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct AddTatekaeView: View {
    @StateObject private var viewModel: AddTatekaeViewModel
    @Environment(\.dismiss) private var dismiss

    init(_ warikanGroupID: EntityID<WarikanGroup>) {
        self._viewModel = StateObject(
            wrappedValue: AddTatekaeViewModel(warikanGroupID)
        )
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section {
                        TextField("例：イタリアンレストランでのランチ", text: $viewModel.tatekaeName)
                    } header: {
                        Text("立替の名目")
                    }
                    Section {
                        TextField("￥ 5000", text: $viewModel.money)
                            .keyboardType(.numberPad)
                    } header: {
                        Text("立替の金額")
                    }
                    Section {
                        Picker("立替人", selection: $viewModel.payer) {
                            Text("未選択").tag(EntityID<Member>?.none)
                            if let members = viewModel.members {
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
                        viewModel.didTapAppendTatakaeButton { dismiss() }
                    },
                           label: {
                        Text("立替を追加")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .background(
                                viewModel.isAppendTatekaeButtonDisabled
                                ? .gray : .blue
                            )
                            .clipShape(Capsule())
                            .padding(.horizontal)
                            .padding(.horizontal)
                    })
                    .disabled(viewModel.isAppendTatekaeButtonDisabled)
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
                    .disabled(viewModel.isDismissButtonDisabled)
                }
            }
            .task {
                await viewModel.getMembers()
            }
            .alert(viewModel.alertText, isPresented: $viewModel.isShowAlert) {}
        }
    }
}

#Preview {
    AddTatekaeView(EntityID<WarikanGroup>(value: "test"))
}
