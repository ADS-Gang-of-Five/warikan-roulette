//
//  TatekaeData.swift
//  Roulette
//  
//  Created by Seigetsu on 2024/03/30
//  
//

import Foundation

struct TatekaeData: Identifiable, Codable {
    let id: EntityID<Tatekae>
    let name: String
    let payer: MemberData
    let recipients: [MemberData]
    let money: Int
    let createdTime: Date
    
    private init(
        id: EntityID<Tatekae>,
        name: String,
        payer: MemberData,
        recipients: [MemberData],
        money: Int,
        createdTime: Date
    ) {
        self.id = id
        self.name = name
        self.payer = payer
        self.recipients = recipients
        self.money = money
        self.createdTime = createdTime
    }
    
    /// 永続化用のデータ型から変換する
    static func create(
        from tatekae: Tatekae,
        memberRepository: MemberRepositoryProtocol
    ) async throws -> Self {
        let payer = try await memberRepository.find(id: tatekae.payer)
        let recipients = try await memberRepository.find(ids: tatekae.recipients)
        return .init(
            id: tatekae.id,
            name: tatekae.name,
            payer: .create(from: payer),
            recipients: recipients.mapToData(),
            money: tatekae.money,
            createdTime: tatekae.createdTime
        )
    }
}

// MARK: - [Tatekae]

extension [Tatekae] {
    func mapToData(withMemberRepository memberRepository: MemberRepositoryProtocol) async throws -> [TatekaeData] {
        var dataList: [TatekaeData] = []
        for seisan in self {
            let data = try await TatekaeData.create(from: seisan, memberRepository: memberRepository)
            dataList.append(data)
        }
        return dataList
    }
}
