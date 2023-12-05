//
//  AddTatekaeView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct AddTatekaeView: View {
    @Binding var isShowAddTatekaeView: Bool
    @State var text = ""
    @State var unluckeyMember = "未選択"

    var body: some View {
        Group {
            HStack {
                Text("立替の名目")
                TextField("", text: $text)
                    .textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("立替の金額")
                TextField("", text: $text)
                    .textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("立替人")
                Spacer()
                Picker("", selection: $unluckeyMember) {
                    Text("sako").tag("sako")
                    Text("seigetsu").tag("seigetsu")
                    Text("maki").tag("maki")
                }
            }
            Button("立替を追加") {
                isShowAddTatekaeView = false
            }
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .frame(width: 250, height: 50)
            .background(.blue)
            .clipShape(Capsule())
            .padding(.top)
        }
        .padding(.horizontal)
    }
}

#Preview {
    AddTatekaeView(isShowAddTatekaeView: Binding.constant(true))
}