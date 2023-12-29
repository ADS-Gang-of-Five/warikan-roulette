//
//  AddGroupListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct AddGroupView: View {
    @State private var groupName = ""
    @State private var memberList: [String] = []
    @State private var additionalMember = ""
    @State private var isValidMemberName = false
    @State private var isShowAddGroupListView = true
    let createWarikanGroup: ( _ groupName: String, _  groupListMemeber: [String]) async -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section {
                        TextField("グループ名を入力", text: $groupName)
                    } header: {
                        Text("割り勘グループ名")
                    }
                    // 追加メンバー・バリデーション（空文字NG・被りNG）
                    Section {
                        HStack {
                            TextField("メンバー名", text: $additionalMember)
                            Button("追加") {
                                memberList.append(additionalMember)
                                additionalMember.removeAll()
                            }
                            .disabled(!isValidMemberName)
                        }
                    } header: {
                        Text("追加メンバー")
                    } footer: {
                        if !isValidMemberName && additionalMember.count != 0 {
                            Text("名前が被っています")
                                .foregroundStyle(Color.red)
                        }
                    }
                    // メンバーリスト、グループ作成ボタン
                    Section {
                        ForEach(memberList.indices, id: \.self) { index in
                            TextField(memberList[index], text: $memberList[index])
                        }
                    } header: {
                        Text("メンバーリスト")
                    } footer: {
                        Button("グループ作成") {
                            Task {
                                await createWarikanGroup(groupName, memberList)
                            }
                            isShowAddGroupListView = false
                        }
                        .disabled(!(groupName.count > 2 && memberList.count >= 2))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding()
                        .padding(.horizontal)
                        .padding(.horizontal)
                        .background(groupName.count > 2 && memberList.count >= 2 ?.blue : .gray)
                        .clipShape(Capsule())
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("割り勘グループ作成")
            .navigationBarTitleDisplayMode(.inline)
            // 右上バツボタン
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isShowAddGroupListView = false
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                }
            }
        }
        .onChange(of: additionalMember) { _, newValue in
            if !memberList.contains(newValue) && additionalMember.count != 0 {
                isValidMemberName = true
            } else {
                isValidMemberName = false
            }
        }
    }
}

#Preview {
    AddGroupView {_, _ in }
}
