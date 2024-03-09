//
//  StubSeisanResultViewModel.swift
//  Roulette
//  
//  Created by Seigetsu on 2024/03/09
//  
//

import Foundation

final class StubSeisanResultViewModel: SeisanResultViewModelProtocol {
    let archivedWarikanGroup: ArchivedWarikanGroupDTO?
    var isShowingAlert = false
    let alertText = "データを取得できなかったためトップに戻ります。"
    
    init(archivedWarikanGroup: ArchivedWarikanGroupDTO?) {
        self.archivedWarikanGroup = archivedWarikanGroup
    }
    
    func reload() {}
}
