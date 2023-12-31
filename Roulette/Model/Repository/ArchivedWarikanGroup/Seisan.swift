//
//  Seisan.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/01
//  
//

import Foundation

/// 清算の一手順。
struct Seisan: Codable {
    /// 債務者。清算で支払いをする人。
    private(set) var debtor: EntityID<Member>
    /// 債権者。清算で受け取る側の人。
    private(set) var creditor: EntityID<Member>
    /// 清算額。
    private(set) var money: Int
}
