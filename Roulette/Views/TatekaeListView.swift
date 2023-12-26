//
//  TransactionRecordListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct TatekaeListView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var isButtonDisabled = true
    @State private var isShowAddTatekaeView = false
    @State private var isShowTatekaeDetailView = false
    @StateObject private var tatekaeListViewModel = TatekaeListViewModel()
    
    let warikanGroup: WarikanGroup
    
    init(warikanGroup: WarikanGroup) {
        self.warikanGroup = warikanGroup
    }
    
    var body: some View {
        ZStack {
            if !tatekaeListViewModel.tatekaes.isEmpty {
                TatekaeList(
                    tatekaes: tatekaeListViewModel.tatekaes,
                    isShowTatekaeDetailView: $isShowTatekaeDetailView
                )
            } else {
                Text("右下のボタンから立替を追加")
            }
            AddButton()
                .onTapGesture {
                    guard !tatekaeListViewModel.members.isEmpty else { return }
                    isShowAddTatekaeView = true
                }
        }
        .sheet(isPresented: $isShowAddTatekaeView,
               onDismiss: {
            // ロード場面を表示し、TatekaeListを再取得し更新
            Task { await tatekaeListViewModel.getTatakaeList(id: warikanGroup.id) }
        },
               content: {
            AddTatekaeView(
                viewModel: tatekaeListViewModel,
                isShowAddTatekaeView: $isShowAddTatekaeView, 
                isButtonDisabled: $isButtonDisabled,
                group: warikanGroup
            )
            .interactiveDismissDisabled()
        })
        .sheet(isPresented: $isShowTatekaeDetailView) {
            //            TatekaeDetailView(isShowTatekaeDetailView: $isShowTatekaeDetailView)
            //                .interactiveDismissDisabled()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("清算", value: Path.confirmView)
            }
        }
        .task {
            await tatekaeListViewModel.getTatakaeList(id: warikanGroup.id)
            await tatekaeListViewModel.getMembers(ids: warikanGroup.members)
        }
    }
}

private struct TatekaeList: View {
    let tatekaes: [Tatekae]
    @Binding var isShowTatekaeDetailView: Bool
    
    var body: some View {
        List {
            Section {
                ForEach(tatekaes) { tatekae in
                    Button(action: {
                        isShowTatekaeDetailView = true
                    }, label: {
                        HStack {
                            Text(tatekae.name)
                                .font(.title2)
                            Spacer()
                            VStack {
                                Text("xxxx年xx月xx日")
                                Text("合計 \(tatekae.money.description)円")
                            }
                            .font(.footnote)
                        }
                        .padding(.vertical, 3)
                    })
                    .foregroundStyle(.primary)
                }
            } header: {
                Text("立替一覧")
            }
        }
    }
}
// swiftlint:disable comment_spacing
//#Preview {
//    TatekaeListView()
//        .environmentObject(ViewRouter())
//}
// swiftlint:enable comment_spacing
