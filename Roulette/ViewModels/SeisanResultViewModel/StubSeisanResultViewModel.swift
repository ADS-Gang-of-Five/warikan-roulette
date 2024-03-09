//
//  StubSeisanResultViewModel.swift
//  Roulette
//  
//  Created by Seigetsu on 2024/03/09
//  
//

import Foundation

final class StubSeisanResultViewModel: SeisanResultViewModelProtocol {
    let archivedWarikanGroup: SeisanResultViewModel.ArchivedWarikanGroupDTO?
    var isShowingAlert = false
    let alertText = "データを取得できなかったためトップに戻ります。"
    
    init(archivedWarikanGroup: SeisanResultViewModel.ArchivedWarikanGroupDTO?) {
        self.archivedWarikanGroup = archivedWarikanGroup
    }
    
    func reload() {}
}

