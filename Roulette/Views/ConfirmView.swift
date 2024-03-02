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
                        Group {
                            HStack {
                                // タプルにする。
                                VStack {
                                    ForEach(warikanGroup.tatekaeListName, id: \.self) { name in
                                        Text(name)
                                    }
                                }
                                Spacer()
                                VStack {
                                    ForEach(warikanGroup.tatekaeListMoney, id: \.self) { money in
                                        Text("\(money)円")
                                    }
                                }
                            }
                        }
                        .font(.title2)
                        HStack {
                            Text("合計金額")
                            Spacer()
                            if let totalAmount = viewModel.totalAmount {
                                Text("\(totalAmount)円")
                            } else {
                                Text("合計金額を計算することができませんでした。")
                            }
                        }
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.top, 1)
                    }
                    // いらなくなってくる。。
                    if !viewModel.unluckyMember {
                        NavigationLink("端数ルーレットする", value: Path.rouletteView)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(.blue)
                            .clipShape(Capsule())
                            .padding(.top)
                    } else {
                        Button {
                            if let id = viewModel.archivedWarikanGroupID {
                                viewRouter.path.append(Path.seisanResultView(id))
                            } else {
                                viewRouter.path.append(Path.rouletteView)
                            }
                            // vmのメソッドを使ってarchiveWarikanGroupを作成する。
                            // seisanResultViewのPathを追加する。
                        } label: {
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
                    // 端数ルーレットをする。 idをRouletteViewへ渡さない。
                    Button {
                        // 処理とラベルを切り替える。
                        // idがある場合とない場合で、表示を切り帰変える。
                    } label: {
                        var aaaa = false
                        if aaaa {
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
//                        サクセスの場合か、ニーズアンラッキーメンバーの場合か
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(.blue)
                    .clipShape(Capsule())
                    .padding(.top)
//                    switch viewModel.selectedGroupSeisanResponse {
//                    case .needsUnluckyMember:
////                        NavigationLink("端数ルーレットする", value: Path.rouletteView)
//
//                    case .success(let seisanList):
//                        Button(action: {
//                            // taskの処理はViewModelにもたす
//                        Task {
//                            _ = await viewModel.archiveWarikanGroup(
//                                id: warikanGroup.id,
//                                seisanList: seisanList,
//                                unluckyMember: nil
//                            )
//                            if let id = viewModel.archivedWarikanGroupID {
//                                viewRouter.path.append(Path.seisanResultView(id))
//                            } else {
//                                
//                            }
//                        }
//                        }, label: {
//
//                        })
//                    case .none:
//                        Text("計算中...")
//                    }
                }
                .padding(.horizontal, 50)
            } else {
                Text("エラーが発生しました。前の画面に一度戻り再度お試しください。")
                    .padding(.horizontal)
            }
        }
        .task {
            do {
                try await viewModel.makeConfirmViewModel()
                _ = await viewModel.calculateTotalAmount()
            } catch {
                print(error)
            }
        }
    }
}
