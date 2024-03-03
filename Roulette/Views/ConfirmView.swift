//
//  ConfirmView.swift
//  Roulette
//
//  Created by sako0602 on 2023/12/04.
//

import SwiftUI

struct ConfirmView: View {
    @StateObject private var viewModel: ConfirmViewModel
    @EnvironmentObject private var viewRouter: ViewRouter
    // アラートのボタンで使用する
    @Environment(\.dismiss) private var dismiss

    init(warikanGroupID: EntityID<WarikanGroup>) {
        _viewModel = StateObject(
            wrappedValue: ConfirmViewModel(warikanGroupID: warikanGroupID)
        )
    }

    var body: some View {
        VStack {
            if let warikanGroup = viewModel.warikanGroupDTO {
                VStack {
                    VStack(alignment: .leading) {
                        Text(warikanGroup.name)
                            .font(.largeTitle)
                            .fontWeight(Font.Weight.heavy)
                        Text("メンバー")
                            .font(.callout)
                            .padding(.top, 1)
                        HStack(spacing: nil) {
                            ForEach(warikanGroup.members.indices, id: \.self) { i in
                                Text(warikanGroup.members[i])
                            }
                        }
                        .font(.title2)
                        Text("立替一覧")
                            .font(.callout)
                            .padding(.top, 1)
                        Group {
                            ForEach(warikanGroup.tatekaeList.indices, id: \.self) { i in
                                HStack {
                                    Text(warikanGroup.tatekaeList[i].name)
                                    Spacer()
                                    Text("\(warikanGroup.tatekaeList[i].money)円")
                                }
                            }
                        }
                        .font(.title2)
                        HStack {
                            Text("合計金額")
                            Spacer()
                            Text("\(warikanGroup.totalAmount)円")
                        }
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.top, 1)
                    }
                    switch viewModel.seisanResponse {
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
                        Button(action: {
                            viewModel.didTappedNavigateToSeisanResultViewButton(
                                completionHandler: {
                                    viewRouter.path.append($0)
                                }
                            )
                        },
                               label: {
                            Text("精算結果を見る")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(.blue)
                                .clipShape(Capsule())
                                .padding(.top)
                        })
                    case .none:
                        Text("計算中...")
                    }
                }
            }
        }
        .padding(.horizontal, 50)
        .task {
            await viewModel.onAppearAction()
        }
        .alert(
            viewModel.alertText,
            isPresented: $viewModel.isShowAlert) {
                Button("戻る") {
                    dismiss()
                }
            }
    }
}
