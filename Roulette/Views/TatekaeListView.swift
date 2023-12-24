//
//  TransactionRecordListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct TatekaeListView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var isShowAddTatekaeView = false
    @State private var isShowTatekaeDetailView = false
    @StateObject private var tatekaeListViewModel = TatekaeListViewModel()
    let groupID: EntityID<WarikanGroup>

    init(groupID: EntityID<WarikanGroup>) {
        self.groupID = groupID
    }

    var body: some View {
        ZStack {
            if !tatekaeListViewModel.tatekaes.isEmpty {
                List {
                    Section {
                        ForEach(tatekaeListViewModel.tatekaes) { tatekae in
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
            } else {
                Text("右下のボタンから立替を追加")
            }
            AddButton()
                .onTapGesture {
                    isShowAddTatekaeView = true
                }
        }
        .sheet(isPresented: $isShowAddTatekaeView) {
            AddTatekaeView(isShowAddTatekaeView: $isShowAddTatekaeView)
                .interactiveDismissDisabled()
        }
        .sheet(isPresented: $isShowTatekaeDetailView) {
            TatekaeDetailView(isShowTatekaeDetailView: $isShowTatekaeDetailView)
                .interactiveDismissDisabled()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("清算", value: Path.confirmView)
            }
        }
        .task {
            await tatekaeListViewModel.getTatakaeList(id: groupID)
        }
    }
}


// swiftlint:disable comment_spacing
//#Preview {
//    TatekaeListView()
//        .environmentObject(ViewRouter())
//}
// swiftlint:enable comment_spacing
