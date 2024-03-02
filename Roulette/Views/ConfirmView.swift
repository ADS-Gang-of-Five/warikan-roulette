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
    
    init(warikanGroupID: EntityID<WarikanGroup>) {
        self._viewModel = StateObject(
            wrappedValue: ConfirmViewModel(warikanGroupID)
        )
    }
    
    var body: some View {
        Group {
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
                            ForEach(warikanGroup.members, id: \.self ) { member in
                                Text(member)
                            }
                        }
                        .font(.title2)
                        Text("立替一覧")
                            .font(.callout)
                            .padding(.top, 1)
                        ForEach(warikanGroup.tatekaeList) { tatekaeList in
                            HStack {
                                Text("\(tatekaeList.name)")
                                Spacer()
                                Text("\(tatekaeList.money)円")
                            }
                        }
                        .font(.title2)
                        HStack {
                            Text("合計金額")
                            Spacer()
                            if let totalAmount = viewModel.totalAmount {
                                Text("\(totalAmount)円")
                            } else {
                                Text("合計金額の計算に失敗しました。")
                            }
                        }
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.top, 1)
                    }
                    Button {
                        if viewModel.unluckyMember == true {
                            viewRouter.path.append(Path.rouletteView)
                        } else {
                            if let id = viewModel.archivedWarikanGroupID {
                                viewRouter.path.append(Path.seisanResultView(id))
                            } else {
                                print("archivedWarikanGroupIDの取得に失敗しました。")
                            }
                        }
                    } label: {
                        if viewModel.unluckyMember == true {
                            Text("端数ルーレットする")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(.blue)
                                .clipShape(Capsule())
                                .padding(.top)
                        } else {
                            Text("清算結果を見る")
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
                }
                .padding(.horizontal, 50)
            } else {
                Text("エラーが発生しました。前の画面に一度戻り再度お試しください。")
                    .padding(.horizontal)
            }
        }
        .task {
            do {
                _ = try await viewModel.makeConfirmViewModel()
                _ = await viewModel.calculateTotalAmount()
                _ = await viewModel.archiveGroupAndNavigateToResult()
            } catch {
                print(error)
            }
        }
    }
}
