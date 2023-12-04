//
//  ViewRouter.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/14.
//

import Foundation

final class ViewRouter_old: ObservableObject {
    static let shared = ViewRouter_old()
    private init(){}
    
    enum Views {
        case view1, view2, view3, view4, view5, view6_1, view6_2, view7, RouletteViewWithSimpleRoulette, RouletteViewWithCharts, view8, view9
    }
    
    @Published private(set) var state: Views = .view1
    
    func changeView(to view: Views) {
        self.state = view
    }
}
