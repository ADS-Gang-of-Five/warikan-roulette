//
//  AddGroupListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct AddGroupListView: View {
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
                            Button("メンバーを追加", action: {})
                            Spacer()
                        }
                    } header: {
                        Text("メンバーリスト")
                    }
                }
                VStack {
                    Spacer()
                    Button(action: {
                        isShowAddGroupListView = false
                    }, label: {
                        Text("グループ作成")
                            .modifier(LongStyle())
                    })
                }
                .padding(.bottom, 1)
            }
            .navigationTitle("割り勘グループ作成")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                }
            }
        }
    }
}

#Preview {
    AddGroupListView(isShowAddGroupListView: Binding.constant(true))
}
