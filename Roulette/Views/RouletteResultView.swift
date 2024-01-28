//
//  RouletteResultView.swift
//  Roulette
//
//  Created by sako0602 on 2023/12/05.
//

import SwiftUI

struct RouletteResultView: View {
    @EnvironmentObject private var mainViewModel: MainViewModel
    
    var body: some View {
        if let unluckyMenber = mainViewModel.unluckyMember {
            VStack(spacing: 10) {
                Group {
                    Text("今回のアンラッキーメンバーは")
#warning("unluckyMenberのIDが削除されたらコメントアウトを削除")
//                                        Text("\(unluckyMenber.name)さんに決定！")
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
        } else {
            //ルーレットを回したのに、アンラッキーメンバーがいないのはおかしい。
         Text("予期せぬエラーが発生しました")
        }
    }
}

private struct MyButton: View {
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
        .environmentObject(MainViewModel())
}
