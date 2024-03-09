//
//  SeisanResultViewModelProtocol.swift
//  Roulette
//  
//  Created by Seigetsu on 2024/03/09
//  
//

import Foundation

@MainActor
protocol SeisanResultViewModelProtocol: ObservableObject {
    var archivedWarikanGroupDTO: SeisanResultViewModel.ArchivedWarikanGroupDTO? { get }
    var isShowAlert: Bool { get set }
    var alertText: String { get }
    
    /// データの読み込みを行う
    func reload() async
}
