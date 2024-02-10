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
                        Button("グループ作成") {
                            viewModel.didTapCreateGroupButton { dismiss() }
                        }
                        .disabled(viewModel.isCreateGroupButtonDisabled)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding()
                        .padding(.horizontal)
                        .padding(.horizontal)
                        .background(
                            viewModel.isCreateGroupButtonDisabled ? .gray : .blue
                        )
                        .clipShape(Capsule())
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("割り勘グループ作成")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                }
            }
            .alert(viewModel.alertText, isPresented: $viewModel.isShowAlert) {}
        }
    }
}

#Preview {
    AddGroupView()
}
