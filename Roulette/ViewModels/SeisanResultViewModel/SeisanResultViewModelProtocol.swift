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
    typealias ArchivedWarikanGroupDTO = SeisanResultView<Self>.ArchivedWarikanGroupDTO
    typealias SeisanDTO = SeisanResultView<Self>.SeisanDTO
    
    var archivedWarikanGroup: ArchivedWarikanGroupDTO? { get }
    var isShowingAlert: Bool { get set }
    var alertText: String { get }
    
    /// データの読み込みを行う
    func reload() async
}
