//
//  View9.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/14.
//

import SwiftUI

struct View9: View {
    let members = ["ひな", "さこ", "かい", "せいげつ", "まき", "じょにー"]
    
    var body: some View {
        NavigationStack{
            ZStack {
                VStack(alignment: .leading) {
                    Text("昼飯")
    //                    .font(.title2)
                        .fontWeight(.medium)
                    Text("合計 1801円")
                    
                    Divider()
                    
                    VStack {
                        ForEach(members, id: \.self) { member in
                            let amount = member == "ひな" ? "301円" : "300円"
                            HStack {
                                Text(member)
                                Spacer()
                                Text(amount)
                                    .foregroundStyle(member == "ひな" ? .red : .primary)
                            }
                        }
                    }
                }
                .font(.title)
                .padding(.horizontal, 50)
                
                NavigationLink {
                    View1()
                } label: {
                    MyButton()
                }

                
            }
        }
        
    }
}

private struct MyButton: View {
    //    let diameter: CGFloat
    
    var body: some View {
        
        VStack {
            Spacer()
            Text("トップに戻る")
                .font(.title)
                .fontWeight(.semibold)
                .padding()
                .foregroundStyle(.white)
                .background(.blue)
                .clipShape(Capsule())
                .padding(.bottom, 1)
        }
        
    }
}

#Preview {
    View9()
}
