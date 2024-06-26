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
    let debtor: Member
    /// 債権者。清算で受け取る側の人。
    let creditor: Member
    /// 清算額。
    let money: Int

    private init(debtor: Member, creditor: Member, money: Int) {
        self.debtor = debtor
        self.creditor = creditor
        self.money = money
    }

    /// 永続化用のデータ型から変換する。
    static func create(from seisan: Seisan, memberRepository: MemberRepositoryProtocol) async throws -> Self {
        let debtor = try await memberRepository.find(id: seisan.debtor)
        let creditor = try await memberRepository.find(id: seisan.creditor)
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

// MARK: - [Seisan]

extension [Seisan] {
    func mapToData(withMemberRepository memberRepository: MemberRepositoryProtocol) async throws -> [SeisanData] {
        var dataList: [SeisanData] = []
        for seisan in self {
            let data = try await SeisanData.create(from: seisan, memberRepository: memberRepository)
            dataList.append(data)
        }
        return dataList
    }
}

// MARK: - [SeisanData]

extension [SeisanData] {
    func mapToEntity() -> [Seisan] {
        self.map { $0.convertToSeisan() }
    }
}
