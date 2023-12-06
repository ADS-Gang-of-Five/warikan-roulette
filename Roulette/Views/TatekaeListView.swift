//
//  TransactionRecordListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct TatekaeListView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State var isShowAddTatekaeView = false
    @State var isShowTatekaeDetailView = false
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
                            .onTapGesture {
                                isShowTatekaeDetailView = true
                            }
                        }
                    } header: {
                        Text("立替一覧")
                    }
                }
            } else {
                Text("右下のボタンから立替を追加")
            }
            MyButton(diameter: 65)
                .onTapGesture {
                    isShowAddTatekaeView = true
                }
                .padding(.bottom, 1)
        }
        .sheet(isPresented: $isShowAddTatekaeView) {
            AddTatekaeView(isShowAddTatekaeView: $isShowAddTatekaeView)
        }
        .sheet(isPresented: $isShowTatekaeDetailView) {
            TatekaeDetailView(isShowTatekaeDetailView: $isShowTatekaeDetailView)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("清算", value: Path.confirmView)
            }
        }
    }
}

private struct MyButton: View {
    let diameter: CGFloat
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .foregroundStyle(Color.blue)
                    .frame(width: diameter, height: diameter)
                    .background(.white)
                    .padding(.trailing)
            }
        }
    }
}

#Preview {
    TatekaeListView()
        .environmentObject(ViewRouter())
}
