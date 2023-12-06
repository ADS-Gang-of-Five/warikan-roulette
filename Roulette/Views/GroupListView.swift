//
//  GroupListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct GroupListView: View {
    @StateObject var viewRouter = ViewRouter()
    @State var isShowAddGroupListView = false
    let groups: [String]
    
    init(groups: [String] = ["Gang of Five", "ひなっこクラブ", "アプリ道場サロン"]) {
        self.groups = groups
    }
    
    var body: some View {
        NavigationStack(path: $viewRouter.path) {
            ZStack {
                if groups != [] {
                        List {
                            ForEach(groups, id: \.self) { group in
                                NavigationLink(group, value: Path.tatekaeListView)
                            }
                        }
                        .navigationDestination(for: Path.self) { path in
                            switch path {
                            case .tatekaeListView:
                                TatekaeListView()
                                    .navigationTitle("Gang of five")
                            case .confirmView:
                                ConfirmView()
                                    .navigationTitle("立て替えの確認")
                                    .navigationBarTitleDisplayMode(.inline)
                            case .rouletteView:
                                RouletteView()
                            case .rouletteResultView:
                                RouletteResultView()
                            case .seisanResultView:
                                SeisanResultView()
                                    .navigationTitle("精算結果")
                                    .navigationBarTitleDisplayMode(.large)
                            }
                        }
                } else {
                    Text("割り勘グループを右下のボタンから追加してください")
                        .font(.title2)
                        .padding(.horizontal, 30)
                }
                MyButton(diameter: 60)
                    .onTapGesture {
                        isShowAddGroupListView = true
                    }
                    .padding(.bottom, 1)
            }
            .navigationTitle("割り勘グループ")
        }
        .environmentObject(viewRouter)
        .sheet(isPresented: $isShowAddGroupListView) {
            AddGroupListView(isShowAddGroupListView: $isShowAddGroupListView)
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
                    .clipShape(Circle())
                    .padding(.trailing)
            }
        }
    }
}

#Preview {
    GroupListView()
}
