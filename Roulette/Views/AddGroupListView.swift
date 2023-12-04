//
//  AddGroupListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct AddGroupListView: View {
    @State private var text = "SampleText"
    @Binding var isShowAddGroupListView: Bool

    var body: some View {
        NavigationStack{
            ZStack {
                Form {
                    Section {
                        TextField("Placeholder", text: $text)
                    } header: {
                        Text("割り勘グループ名")
                    }
                    Section {
                        TextField("Placeholder", text: $text)
                        TextField("Placeholder", text: $text)
                        TextField("Placeholder", text: $text)
                        TextField("Placeholder", text: $text)
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
        }
    }
}

#Preview {
    AddGroupListView(isShowAddGroupListView: Binding.constant(true))
}
