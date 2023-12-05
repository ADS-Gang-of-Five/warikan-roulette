//
//  RouletteResultView.swift
//  Roulette
//
//  Created by sako0602 on 2023/12/05.
//

import SwiftUI

struct RouletteResultView: View {
    var body: some View {
        VStack(spacing: 10) {
            Group {
                Text("ひなが")
                Text("多く払うよ！")
            }
            .font(.title)
            .fontWeight(.bold)
            NavigationLink("OK", value: Path.seisanResultView)
                .padding(.vertical, 10)
                .padding(.horizontal, 50)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .background(.blue)
                .clipShape(Capsule(), style: FillStyle())
                .padding(.top)
            
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
    RouletteResultView()
}
