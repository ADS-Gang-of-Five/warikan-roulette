//
//  AddGroupListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct AddGroupView: View {
    @StateObject private var viewModel = AddGroupViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section {
                        TextField("グループ名を入力", text: $viewModel.groupName)
                    } header: {
                        Text("割り勘グループ名")
                    }
                    Section {
                        HStack {
                            TextField("メンバー名", text: $viewModel.additionalMember)
                            Button("追加") {
                                viewModel.didTapAddMemberButton()
                            }
                            .disabled(viewModel.isAddMemberButtonDisabled)
                        }
                    } header: {
                        Text("追加メンバー")
                    }
                    Section {
                        ForEach(viewModel.memberList.indices, id: \.self) { index in
                            TextField(
                                viewModel.memberList[index],
                                text: $viewModel.memberList[index]
                            )
                        }
                    } header: {
                        Text("メンバーリスト")
                    } footer: {
                        Button(action: {
                            viewModel.didTapCreateGroupButton { dismiss() }
                        }, label: {
                            Text("グループ作成")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 20)
                        })
                        .disabled(viewModel.isCreateGroupButtonDisabled)
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("割り勘グループ作成")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.didTapDismissButtonAction(dismissFunction: dismiss.callAsFunction)
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                    .disabled(viewModel.isDissmissButtonDisabled)
                }
            }
            .alert(viewModel.alertText, isPresented: $viewModel.isShowAlert) {}
            .confirmationDialog(
                "割り勘グループの作成を中止しますか？\n（入力内容は破棄されます。）",
                isPresented: $viewModel.isShowDismissConfirmationDialog,
                titleVisibility: .visible
            ) {
                Button("作成を中止する", role: .destructive, action: dismiss.callAsFunction)
                Button("作成を続ける", role: .cancel) {}
            }
        }
        .interactiveDismissDisabled(viewModel.hasAnyInput)
    }
}

#Preview {
    AddGroupView()
}
