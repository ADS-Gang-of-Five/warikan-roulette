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
            Form {
                Section {
                    TextField("例：イタリアンレストランでのランチ", text: $viewModel.tatekaeName)
                        .disabled(viewModel.isTatekaeNameTextFieldDisabled)
                } header: { Text("立替の名目") }
                Section {
                    TextField("￥ 5000", text: $viewModel.money)
                        .keyboardType(.numberPad)
                        .disabled(viewModel.isMoneyTextFieldDisabled)
                } header: { Text("立替の金額") }
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
                    .disabled(viewModel.isPayerPickerDisabled)
                }
            }
            .navigationTitle("立替の追加")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.didTapDismissButtonAction(dismissFunction: dismiss.callAsFunction)
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                    .disabled(viewModel.isDismissButtonDisabled)
                    .confirmationDialog(
                        "立替の追加を中止しますか？\n（入力内容は破棄されます。）",
                        isPresented: $viewModel.isShowDismissConfirmationDialog,
                        titleVisibility: .visible
                    ) {
                        Button("立替の追加を中止する", role: .destructive, action: dismiss.callAsFunction)
                        Button("立替の追加を続ける", role: .cancel) {}
                    }
                }
            }
            .task { await viewModel.getMembers() }
            .alert(viewModel.alertText, isPresented: $viewModel.isShowAlert) {
            }
            .overlay(alignment: .bottom) {
                Button(action: {
                    viewModel.didTapAppendTatakaeButton { dismiss() }
                }, label: {
                    Text("立替を追加")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                })
                .disabled(viewModel.isAppendTatekaeButtonDisabled)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .padding(.horizontal)
            }
        }
        .interactiveDismissDisabled(viewModel.hasAnyInput)
    }
}

#Preview {
    AddTatekaeView(EntityID<WarikanGroup>(value: "test"))
}
