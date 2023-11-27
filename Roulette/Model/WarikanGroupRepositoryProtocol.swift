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
    func save(_ item: WarikanGroup)
    /// 指定したインデックスの割り勘グループを削除する。
    func remove(at indices: [Int])
}
