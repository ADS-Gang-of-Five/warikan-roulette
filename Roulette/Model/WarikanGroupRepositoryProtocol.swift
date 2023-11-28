//
//  WarikanGroupRepositoryProtocol.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/11/28
//  
//

import Foundation

protocol WarikanGroupRepositoryProtocol {
    /// 割り勘グループを全件取得する。
    func findAll() -> [WarikanGroup]
    
    /// 割り勘グループを保存する。
    ///
    /// 既に存在するIDの場合は更新、存在しないIDの場合は末尾に新規作成する。
    func save(_ item: WarikanGroup)
    
    /// 指定したインデックスの割り勘グループを削除する。
    func remove(at indices: [Int])
}
