//
//  View7.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/14.
//

import SwiftUI

struct View7: View {
    let members = ["ひな", "さこ", "かい", "せいげつ", "まき", "じょにー"]
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
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
                }
                Spacer()
                NavigationLink {
                    RouletteViewWithCharts()
                } label: {
                    Text("端数ルーレットする")
                        .modifier(LongStyle())
                        .padding(.bottom, 1)
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
            Button(action: {
                ViewRouter.shared.changeView(to: .RouletteViewWithSimpleRoulette)
            }, label: {
                Text("端数ルーレットする")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                    .foregroundStyle(.white)
                    .background(.blue)
                    .clipShape(Capsule())
            })
            .padding(.bottom, 1)
        }
        
    }
}

#Preview {
    View7()
}
