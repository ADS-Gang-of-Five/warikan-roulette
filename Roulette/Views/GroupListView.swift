//
//  GroupListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI


//// 初期画面
//
//struct GroupListView: View {
//    @StateObject var viewRouter = ViewRouter()
//    @State var isShowAddGroupListView = false
//    
//    var body: some View {
//        NavigationStack(path: $viewRouter.path) {
////            List {
//////                NavigationLink
////            }
////            .navigationTitle("割り勘グループ")
////            .navigationDestination(for: Path.self) { path in
////                switch path {
////                case .addGroupView:
////                    AddGroupListView()
////                }
////            }
//            ZStack {
//                Text("割り勘グループを右下のボタンから追加してください")
//                    .font(.title2)
//                    .padding(.horizontal, 30)
//                
//                MyButton(diameter: 65)
//                    .onTapGesture {
//                        isShowAddGroupListView = true
//                    }
//            }
//            .navigationTitle("割り勘グループ")
//        }
//        .sheet(isPresented: $isShowAddGroupListView, content: {
//            AddGroupListView(isShowAddGroupListView: $isShowAddGroupListView)
//        })
//    }
//}
//
//private struct MyButton: View {
//    let diameter: CGFloat
//    
//    var body: some View {
//        HStack {
//            Spacer()
//            VStack {
//                Spacer()
//                    Image(systemName: "plus.circle.fill")
//                        .resizable()
//                        .foregroundStyle(Color.blue)
//                        .frame(width: diameter, height: diameter)
//                        .background(.white)
//                
//                .padding(.trailing)
//            }
//        }
//    }
//}
//
//#Preview {
//    GroupListView()
//}







// すでに割り勘ループが作成されている場合

struct GroupListView: View {
    @StateObject var viewRouter = ViewRouter()
    @State var isShowAddGroupListView = false
    
    var body: some View {
        NavigationStack(path: $viewRouter.path) {
            ZStack {
                List {
                    NavigationLink("Gang of Five", value: Path.tatekaeListView)
                    NavigationLink("ひなっこクラブ", value: Path.tatekaeListView)
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
                    }
                }
                
                MyButton(diameter: 65)
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
                
                .padding(.trailing)
            }
        }
    }
}

#Preview {
    GroupListView()
}
