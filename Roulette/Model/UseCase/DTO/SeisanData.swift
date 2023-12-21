//
//  SeisanData.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/21
//  
//

import Foundation

/// 清算の一手順。
struct SeisanData {
    /// 債務者。清算で支払いをする人。
    private(set) var debtor: Member
    /// 債権者。清算で受け取る側の人。
    private(set) var creditor: Member
    /// 清算額。
    private(set) var money: Int

    /// 永続化のためのデータ型に変換する。
    /// - IMPORTANT: 原則ユースケース以外の場所で使用しないこと。
    func convertToSeisan() -> Seisan {
        Seisan(
            debtor: debtor.id,
            creditor: creditor.id,
            money: money
        )
    }
}
