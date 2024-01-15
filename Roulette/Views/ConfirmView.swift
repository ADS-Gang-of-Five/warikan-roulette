//
//  ConfirmView.swift
//  Roulette
//
//  Created by sako0602 on 2023/12/04.
//

import SwiftUI

struct ConfirmView: View {
    @EnvironmentObject private var mainViewModel: MainViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Gang of Five")
                .font(.largeTitle)
                .fontWeight(Font.Weight.heavy)
            Text("メンバー")
                .font(.callout)
                .padding(.top, 1)
            HStack(spacing: nil) {
                Text("Sako,")
                Text("Seigetsu,")
                Text("Maki")
            }
            .font(.title2)
            Text("立替一覧")
                .font(.callout)
                .padding(.top, 1)
            Group {
                HStack {
                    Text("朝食")
                    Spacer()
                    Text("3,000円")
                }
                HStack {
                    Text("昼食")
                    Spacer()
                    Text("3,000円")
                }
                HStack {
                    Text("夕食")
                    Spacer()
                    Text("4,000円")
                }
            }
            .font(.title2)
            HStack {
                Text("合計金額")
                Spacer()
                Text("10,000円")
            }
            .font(.title)
            .fontWeight(.semibold)
            .padding(.top, 1)
        }
        .padding(.horizontal, 50)
        NavigationLink("端数ルーレットする", value: Path.rouletteView)
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(.blue)
            .clipShape(Capsule())
            .padding(.top)
    }
}

#Preview {
    ConfirmView()
        .environmentObject(MainViewModel())
}
