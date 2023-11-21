//
//  View5.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/14.
//

import SwiftUI

struct View5: View {
    var body: some View {
        NavigationStack{
            VStack {

                VStack(alignment: .leading, content: {
                    VStack(alignment: .leading, content: {
                        Text("合計 〇〇〇〇円")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("AさんがXXXを立て替えた。")
                            .font(.title2)
            //                .padding(.top, 5)
                    })
                    
                    VStack(alignment: .leading, content: {
                        Text("合計数")
                            .font(.title2)
                        HStack {
                            SubView(name: "ひな")
                            SubView(name: "さこ")
                            SubView(name: "かい")
                        }
                        HStack {
                            SubView(name: "まき")
                            SubView(name: "せいげつ")
                            SubView(name: "じょにー")
                        }
                    })
                    .padding(.top)
                })
                
                NavigationLink {
                    View6_1()
                } label: {
                    Text("立て替え追加")
                        .modifier(LongStyle())
                        .padding(.top, 50)
                }
            }
        }
    }
}

private struct SubView: View {
    let name: String
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle")
            Text(name)
        }
        .padding(3)
        .border(Color.black)
    }
}

#Preview {
    View5()
}
