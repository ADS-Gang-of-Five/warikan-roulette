//
//  TransactionRecordListView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

//// 初期画面
//
//struct TatekaeListView: View {
//    @EnvironmentObject var viewRouter: ViewRouter
//    
//    var body: some View {
//        NavigationStack(path: $viewRouter.path) {
//            ZStack {
//                Text("右下のボタンから立替を追加")
//                
//                MyButton(diameter: 65)
//            }
//        }
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                Button("精算") {
//                    
//                }
//                .bold()
//            }
//        }
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
//    TatekaeListView()
//        .environmentObject(ViewRouter())
//}

















struct TatekaeListView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State var isShowAddTatekaeView = false
    @State var isShowTatekaeDetailView = false
    
    var body: some View {
//        NavigationStack(path: $viewRouter.path)
            ZStack {
                List {
                    HStack {
                        Text("朝食")
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
                    HStack {
                        Text("昼食")
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
                    HStack {
                        Text("夕食")
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
                
                MyButton(diameter: 65)
                    .onTapGesture {
                        isShowAddTatekaeView = true
                    }
                    .padding(.bottom, 1)
            }
        
        .sheet(isPresented: $isShowAddTatekaeView, content: {
            AddTatekaeView(isShowAddTatekaeView: $isShowAddTatekaeView)
        })
        .sheet(isPresented: $isShowTatekaeDetailView, content: {
            TatekaeDetailView(isShowTatekaeDetailView: $isShowTatekaeDetailView)
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("清算", value: Path.confirmView)
            }
        }
//        .navigationDestination(for: Path.self) { path in
//            switch path {
//            case .confirmView:
//                ConfirmView()
//            case .tatekaeListView:
//                TatekaeListView()
//            }
//        }
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