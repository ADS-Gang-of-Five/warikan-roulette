//
//  View6_1.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/14.
//

import SwiftUI

struct View6_1: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack{
                    ZStack {
                        List {
                            HStack {
                                Text("昼飯")
                                    .font(.title2)
                                Spacer()
                                VStack {
                                    Text("2023年11月14日")
                                    Text("合計 XXXXX円")
                                }
                                .font(.footnote)
                            }
                            .padding(.vertical, 3)
                        }
                        NavigationLink {
                            View7()
                        } label: {
                            Text("合計清算")
                        }
                        .frame(width: geometry.size.width * 0.3)
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding()
                        .foregroundStyle(.white)
                        .background(.blue)
                        .clipShape(Capsule())
                        .offset(x: 100,y: 300)
                        
                    }
                    
                }
            }
            .navigationTitle("Gang of Six")
            
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
                    ViewRouter_old.shared.changeView(to: .view7)
                }, label: {
                    Text("合計精算")
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
    View6_1()
}
