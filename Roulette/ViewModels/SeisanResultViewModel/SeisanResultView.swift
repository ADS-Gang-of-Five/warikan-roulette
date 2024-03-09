//
//  SeisanResultView.swift
//  Roulette
//
//  Created by sako0602 on 2023/12/05.
//

import SwiftUI

struct SeisanResultView<ViewModel>: View where ViewModel: SeisanResultViewModelProtocol {
    @EnvironmentObject private var viewRouter: ViewRouter
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: @escaping @autoclosure () -> ViewModel) {
        self._viewModel = .init(wrappedValue: viewModel())
    }

    var body: some View {
        VStack(spacing: 20) {
            if let archivedWarikanGroupDTO = viewModel.archivedWarikanGroup {
                Text("立て替え一覧")
                HStack {
                    let tatekaeList = archivedWarikanGroupDTO.tatekaeList
                    ForEach(tatekaeList, id: \.self) { tatekae in
                        Text(tatekae)
                    }
                }
                Text("アンラッキーメンバー")
                Text(archivedWarikanGroupDTO.unluckyMember ?? "なし")
                Text("合計金額")
                Text("\(archivedWarikanGroupDTO.totalAmount)円")
                Text("清算結果")
                if archivedWarikanGroupDTO.seisanList.isEmpty {
                    Text("清算なし")
                } else {
                    ForEach(archivedWarikanGroupDTO.seisanList.indices, id: \.self) { index in
                        let seisan = archivedWarikanGroupDTO.seisanList[index]
                        Text("\(seisan.creditor)が\(seisan.debtor)に\(seisan.money)円渡す")
                    }
                }
                Button("トップに戻る") {
                    viewRouter.path.removeLast(viewRouter.path.count)
                }
            }
        }
        .alert(viewModel.alertText, isPresented: $viewModel.isShowingAlert) {
            Button("戻る") {
                viewRouter.path.removeLast(viewRouter.path.count)
            }
        }
        .task {
            await viewModel.reload()
        }
    }
}

#Preview {
    let data = SeisanResultView<StubSeisanResultViewModel>.ArchivedWarikanGroupDTO(
        name: "サンプルグループ",
        tatekaeList: ["昼食代", "タクシー代", "宿泊費"],
        totalAmount: 12000,
        unluckyMember: "さこ",
        seisanList: [
            .init(debtor: "霽月", creditor: "さこ", money: 1600),
            .init(debtor: "霽月", creditor: "まき", money: 1700)
        ]
    )
    return SeisanResultView(
        viewModel: StubSeisanResultViewModel(archivedWarikanGroup: data)
    )
}
