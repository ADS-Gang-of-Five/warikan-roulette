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
    let tatekaes: [String]
    
    init(tatekaes: [String] = ["朝食", "昼食", "夕食"]) {
        self.tatekaes = tatekaes
    }
    
    var body: some View {
        ZStack {
            if tatekaes != [] {
                List {
                    Section {
                        ForEach(tatekaes, id: \.self) { tatekae in
                            Button(action: {
                                isShowTatekaeDetailView = true
                            }, label: {
                                HStack {
                                    Text(tatekae)
                                        .font(.title2)
                                    Spacer()
                                    VStack {
                                        Text("2023年11月14日")
                                        Text("合計 XXXXX円")
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
    }
}

#Preview {
    TatekaeListView()
        .environmentObject(ViewRouter())
}
