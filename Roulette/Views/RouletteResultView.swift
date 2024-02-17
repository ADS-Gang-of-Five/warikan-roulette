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
        if let unluckyMenber = mainViewModel.unluckyMemberName {
            VStack(spacing: 10) {
                Group {
                    Text("今回のアンラッキーメンバーは")
                    Text("\(unluckyMenber)さんに決定！")
                }
                .font(.title)
                .fontWeight(.bold)
                if let id = mainViewModel.archivedWarkanGroupID {
                    NavigationLink("OK", value: Path.seisanResultView(id))
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
        } else {
            // ルーレットを回したのに、アンラッキーメンバーがいないのはおかしい。
         Text("予期せぬエラーが発生しました")
        }
    }
}

#warning("SeisanResultViewへのリンクは未変更")
struct NewRouletteResultView: View {
    @StateObject private var viewModel: RouletteResultViewModel

    init(archivedWarikanGroupID: EntityID<ArchivedWarikanGroup>) {
        self._viewModel = StateObject(
            wrappedValue: RouletteResultViewModel(
                archivedWarikanGroupID
            )
        )
    }

    var body: some View {
        VStack(spacing: 10) {
            if let unluckyMenber = viewModel.unluckyMember {
                Group {
                    Text("今回のアンラッキーメンバーは")
                    Text("\(unluckyMenber.name)さんに決定！")
                }
                .font(.title)
                .fontWeight(.bold)
//                NavigationLink("OK", value: Path.seisanResultView)
//                    .padding(.vertical, 10)
//                    .padding(.horizontal, 50)
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .foregroundStyle(.white)
//                    .background(.blue)
//                    .clipShape(Capsule(), style: FillStyle())
//                    .padding(.top)
            }
        }
        .task {
            await viewModel.getUnluckyMember()
        }
        .alert(viewModel.aletText, isPresented: $viewModel.isShowAlert) {}
    }
}

#Preview {
    RouletteResultView()
        .environmentObject(MainViewModel())
}
