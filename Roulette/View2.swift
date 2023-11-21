//
//  View2.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/14.
//

import SwiftUI

struct View2: View {
    @State private var text = "SampleText"

    var body: some View {
        NavigationStack{
            ZStack {
                Form {
                    Section {
                        TextField("Placeholder", text: $text)
                    } header: {
                        Text("グループ名")
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
                    NavigationLink {
                        View3()
                    } label: {
                        Text("グループを作る")
                            .modifier(LongStyle())
                    }
                }
                .padding(.bottom, 1)
            }
        }
    }
}

#Preview {
    View2()
}
