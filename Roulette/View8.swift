//
//  View8.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/14.
//

import SwiftUI

struct View8: View {
    var body: some View {
        NavigationStack{
            VStack(spacing: 10) {
                
                Group {
                    Text("ひなが")
                    Text("1円")
                    Text("　払うよ！")
                }
                .font(.title)
                .fontWeight(.bold)
                
                NavigationLink {
                    View9()
                } label: {
                    Text("OK")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 50)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .background(.blue)
                        .clipShape(Capsule(), style: FillStyle())
                }
                .padding(.top)
            }
        }
    }
}

#Preview {
    View8()
}
