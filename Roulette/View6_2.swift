//
//  View6_2.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/14.
//

import SwiftUI

struct View6_2: View {
    let members = ["ひな", "さこ", "かい", "せいげつ", "まき", "じょにー"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading) {
                    Text("昼飯")
                        .font(.title2)
                        .fontWeight(.medium)
                    Text("合計 1801円")
                    
                    
                    VStack {
                        ForEach(members, id: \.self) { member in
                            HStack {
                                Text(member)
                                Spacer()
                                Text("300円")
                            }
                        }
                        Divider()
                        HStack {
                            Text("端数")
                            Spacer()
                            Text("1円")
                                .fontWeight(.semibold)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.top)
                }
                .font(.title)
                .padding(.horizontal, 50)

                
                MyButton()
            }
            .navigationTitle("詳細")
        }
    }
}

private struct MyButton: View {
//    let diameter: CGFloat
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Button(action: {
                    ViewRouter_old.shared.changeView(to: .view6_1)
                }, label: {
                    Text("戻る")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding()
                        .foregroundStyle(.white)
                        .background(.blue)
                        .clipShape(Capsule())
                })
                .padding(.bottom, 1)
                .padding(.trailing)
            }
        }
    }
}

#Preview {
    View6_2()
}
