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
                NavigationLink(
                    value: ViewRouter.Path.seisanResultView(viewModel.archivedWarikanGroupID)
                ) {
                    Text("OK")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .padding(.top)
            }
        }
        .task {
            await viewModel.getUnluckyMember()
        }
        .alert(viewModel.aletText, isPresented: $viewModel.isShowAlert) {}
        .navigationBarBackButtonHidden()
    }
}
