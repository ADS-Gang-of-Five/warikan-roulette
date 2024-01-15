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
        if let warikanGroup = mainViewModel.selectedGroup,
           let members = mainViewModel.selectedGroupMembers,
           let tatekaes = mainViewModel.selectedGroupTatekaes {
            VStack(alignment: .leading) {
                Text(warikanGroup.name)
                    .font(.largeTitle)
                    .fontWeight(Font.Weight.heavy)
                Text("メンバー")
                    .font(.callout)
                    .padding(.top, 1)
                HStack(spacing: nil) {
                    ForEach(members) { member in
                        Text(member.name)
                    }
                }
                .font(.title2)
                Text("立替一覧")
                    .font(.callout)
                    .padding(.top, 1)
                Group {
                    ForEach(tatekaes) { tatekae in
                        HStack {
                            Text(tatekae.name)
                            Spacer()
                            Text("\(tatekae.money)円")
                        }
                    }
                }
                .font(.title2)
                HStack {
                    Text("合計金額")
                    Spacer()
                    let sum = tatekaes.reduce(0) { partialResult, tatekae in
                        partialResult + tatekae.money
                    }
                    Text("\(sum)円")
                }
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, 1)
            }
            .padding(.horizontal, 50)
            switch mainViewModel.selectedGroupSeisanResponse {
            case .needsUnluckyMember:
                NavigationLink("端数ルーレットする", value: Path.rouletteView)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(.blue)
                    .clipShape(Capsule())
                    .padding(.top)
            case .success:
                NavigationLink("精算結果を見る", value: Path.seisanResultView)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(.blue)
                    .clipShape(Capsule())
                    .padding(.top)
            case .none:
                Text("エラー")
            }
        } else {
            Text("エラーが発生しました。前の画面に一度戻り再度お試しください。")
                .padding(.horizontal)
        }
    }
}

#Preview {
    ConfirmView()
        .environmentObject(MainViewModel())
}
