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

    private init(debtor: Member, creditor: Member, money: Int) {
        self.debtor = debtor
        self.creditor = creditor
        self.money = money
    }

    /// 永続化用のデータ型から変換する。
    static func create(from seisan: Seisan, memberRepository: MemberRepositoryProtocol) async throws -> Self {
        guard let debtor = try await memberRepository.find(id: seisan.debtor) else {
            throw ValidationError.notFoundID(seisan.debtor)
        }
        guard let creditor = try await memberRepository.find(id: seisan.creditor) else {
            throw ValidationError.notFoundID(seisan.debtor)
        }
        return .init(
            debtor: debtor,
            creditor: creditor,
            money: seisan.money
        )
    }

    /// 永続化用のデータ型に変換する。
    /// - IMPORTANT: 原則ユースケース以外の場所で使用しないこと。
    func convertToSeisan() -> Seisan {
        Seisan(
            debtor: debtor.id,
            creditor: creditor.id,
            money: money
        )
    }
}
