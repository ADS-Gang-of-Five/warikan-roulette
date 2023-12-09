//
//  AddGroupListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct AddGroupView: View {
    @State private var groupName = "Gang of Five"
    @State private var member1 = "Sako"
    @State private var member2 = "Seigetsu"
    @State private var member3 = "Maki"
    @Binding var isShowAddGroupListView: Bool
    
    var body: some View {
        NavigationStack{
            ZStack {
                Form {
                    Section {
                        TextField("", text: $groupName)
                    } header: {
                        Text("割り勘グループ名")
                    }
                    Section {
                        TextField("", text: $member1)
                        TextField("", text: $member2)
                        TextField("", text: $member3)
                        HStack {
                            Spacer()
                            Button("追加", action: {})
                            Spacer()
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
