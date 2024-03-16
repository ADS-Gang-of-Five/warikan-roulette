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
    @State private var tatekaeListIsExpanded = false
    
    init(viewModel: @escaping @autoclosure () -> ViewModel) {
        self._viewModel = .init(wrappedValue: viewModel())
    }

    var body: some View {
        VStack(spacing: 20) {
            if let archivedWarikanGroupDTO = viewModel.archivedWarikanGroup {
                List {
                    Section(isExpanded: $tatekaeListIsExpanded) {
                        let tatekaeList = archivedWarikanGroupDTO.tatekaeList
                        ForEach(tatekaeList, id: \.self) { tatekae in
                            Text(tatekae)
                        }
                    } header: {
                        Text("立て替え")
                            .font(.subheadline)
                    }
                    
                    Section {
                        Text("\(archivedWarikanGroupDTO.totalAmount)円")
                    } header: {
                        Text("合計金額")
                            .font(.subheadline)
                    }
                    
                    Section {
                        Text(archivedWarikanGroupDTO.unluckyMember ?? "なし")
                    } header: {
                        Text("アンラッキーメンバー")
                            .font(.subheadline)
                    }
                    
                    Section {
                        if archivedWarikanGroupDTO.seisanList.isEmpty {
                            Text("清算なし")
                        } else {
                            ForEach(archivedWarikanGroupDTO.seisanList.indices, id: \.self) { index in
                                let seisan = archivedWarikanGroupDTO.seisanList[index]
                                Text("\(seisan.creditor) が \(seisan.debtor) に \(seisan.money)円 渡す")
                            }
                        }
                    } header: {
                        Text("清算結果")
                            .font(.subheadline)
                    }
                }
                .listStyle(.sidebar)
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewRouter.path.removeLast(viewRouter.path.count)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.backward")
                            .fontWeight(.semibold)
                        Text("トップに戻る")
                    }
                }
            }
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
    return NavigationStack {
        SeisanResultView(
            viewModel: StubSeisanResultViewModel(archivedWarikanGroup: data)
        )
        .navigationTitle("精算結果")
        .navigationBarTitleDisplayMode(.large)
    }
}
