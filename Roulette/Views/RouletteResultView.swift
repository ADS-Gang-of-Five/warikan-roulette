//
//  RouletteResultView.swift
//  Roulette
//
//  Created by sako0602 on 2023/12/05.
//

import SwiftUI

struct RouletteResultView: View {
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
                NavigationLink(value: Path.seisanResultView(viewModel.archivedWarikanGroupID)) {
                    Text("OK") 
                        .padding(.vertical, 10)
                        .padding(.horizontal, 50)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .background(.blue)
                        .clipShape(Capsule())
                }
                .padding(.top)
            }
        }
        .task {
            await viewModel.getUnluckyMember()
        }
        .alert(viewModel.aletText, isPresented: $viewModel.isShowAlert) {}
    }
}
