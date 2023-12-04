//
//  ContentView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/07.
//

import SwiftUI

//struct ContentView: View {
//    @StateObject private var viewRouter = ViewRouter.shared
//
//    var body: some View {
//        switch viewRouter.state {
//        case .view1:
//            View1()
//        case .view2:
//            View2()
//        case .view3:
//            View3()
//        case .view4:
//            View4()
//        case .view5:
//            View5()
//        case .view6_1:
//            View6_1()
//        case .view6_2:
//            View6_2()
//        case .view7:
//            View7()
//        case .RouletteViewWithSimpleRoulette:
//            RouletteViewWithSimpleRoulette()
//        case .RouletteViewWithCharts:
//            RouletteViewWithCharts()
//        case .view8:
//            View8()
//        case .view9:
//            View9()
//        }
//    }
//}
//
//
//
//
//#Preview {
//    ContentView()
//}













struct ContentView: View {
    var body: some View {
        TabView{
            GroupListView()
                .tabItem { Label("割り勘グループ", systemImage: "person.3.fill") }
            ArchiveView()
                .tabItem { Label("清算済グループ", systemImage: "archivebox.fill") }
        }
    }
}

#Preview {
    ContentView()
}


// ContentView,ViewRouterの再定義、GroupListView,ArchiveView,AddGroupListView,TatekaeListViewの追加
