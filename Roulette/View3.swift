//
//  View3.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/14.
//

import SwiftUI

struct View3: View {
    private let groups = ["Gang of Six", "ひなっこクラブ"]
    
    var body: some View {
        NavigationStack {
            ZStack {
//                Text("割り勘グループを右下のボタンから追加してください。")
//                    .font(.title2)
//                    .padding(.horizontal, 30)
                
                List(groups, id: \.self) { group in
                    Text(group)
                        .font(.title2)
                        .padding(.vertical, 5)
                }
                .listStyle(.grouped)
                
                MyButton(diameter: 70)
            }
            .navigationTitle("割り勘グループ")
        }
    }
}

private struct MyButton: View {
    let diameter: CGFloat
    
    var body: some View {
        NavigationStack{
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    NavigationLink {
                        View4()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: diameter, height: diameter)
                            .background(.white)
                            .clipShape(Circle())
                    }
                    .padding(.trailing)
                }
            }
        }
    }
}

#Preview {
    View3()
}
