//
//  View4.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/14.
//

import SwiftUI

struct View4: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Text("右下のボタンから立替リスト追加")
                    .font(.title2)
                    .padding(.horizontal, 30)
                
                NavigationLink {
                    View5()
                } label: {
                   MyButton(diameter: 70)
                }

//                MyButton(diameter: 70)
            }
            .navigationTitle("割り勘グループ")
        }
    }
}

private struct MyButton: View {
    let diameter: CGFloat
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundStyle(Color.blue)
                        .frame(width: diameter, height: diameter)
                        .background(.white)
                
                .padding(.trailing)
            }
        }
    }
}

//private struct MyButton: View {
//    let diameter: CGFloat
//    
//    var body: some View {
//        HStack {
//            Spacer()
//            VStack {
//                Spacer()
//                Button(action: {
//                    ViewRouter.shared.changeView(to: .view5)
//                }, label: {
//                    Image(systemName: "plus.circle.fill")
//                        .resizable()
//                        .frame(width: diameter, height: diameter)
//                        .background(.white)
//                })
//                .padding(.trailing)
//            }
//        }
//    }
//}

#Preview {
    View4()
}
