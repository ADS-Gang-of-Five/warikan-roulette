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
//    @State private var member1 = "Sako"
//    @State private var member2 = "Seigetsu"
//    @State private var member3 = "Maki"
//    @State private var member4 = ""
    @State private var addMember = ""
    @Binding var isShowAddGroupListView: Bool
//    let warikanGroupCreate: (WarikanGroup) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section {
                        TextField("グループ名を入力", text: $groupName)
                    } header: {
                        Text("割り勘グループ名")
                    }
                    Section {
                        HStack {
                            TextField("メンバー名", text: $addMember)
                            Button("追加") {
                                // 被っていないかチェックを行う。
                            }
                        }
                    } header: {
                        Text("追加メンバー")
                    }
                    Section {
                        ForEach(memberList, id: \.self) { member in
                            Text(member)
                        }
                    } header: {
                        Text("メンバーリスト")
                    } footer: {
                        Button("グループ作成") {
                            isShowAddGroupListView = false
                        }
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding()
                        .padding(.horizontal)
                        .padding(.horizontal)
                        .background(.blue)
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
                        isShowAddGroupListView = false
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                }
            }
        }
    }
}

#Preview {
    AddGroupView(isShowAddGroupListView: Binding.constant(true))
}
