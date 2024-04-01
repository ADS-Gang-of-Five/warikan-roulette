//
//  WarikanGroupData.swift
//  Roulette
//  
//  Created by Seigetsu on 2024/03/30
//  
//

import Foundation

struct WarikanGroupData: Identifiable, Codable {
    let id: EntityID<WarikanGroup>
    let name: String
    let members: [MemberData]
    let tatekaeList: [TatekaeData]
    
    private init(
        id: EntityID<WarikanGroup>,
        name: String,
        members: [MemberData],
        tatekaeList: [TatekaeData]
    ) {
        self.id = id
        self.name = name
        self.members = members
        self.tatekaeList = tatekaeList
    }

    /// 永続化用のデータ型から変換する。
    static func create(
        from group: WarikanGroup,
        memberRepository: MemberRepositoryProtocol,
        tatekaeRepository: TatekaeRepositoryProtocol
    ) async throws -> Self {
        let members = try await memberRepository.find(ids: group.members)
        let tatekaeList = try await tatekaeRepository.find(ids: group.tatekaeList)
        return .init(
            id: group.id,
            name: group.name,
            members: members.mapToData(),
            tatekaeList: try await tatekaeList.mapToData(withMemberRepository: memberRepository)
        )
    }
}

// MARK: - [WarikanGroup]

extension [WarikanGroup] {
    func mapToData(
        withMemberRepository memberRepository: MemberRepositoryProtocol,
        withTatekaeRepository tatekaeRepository: TatekaeRepositoryProtocol
    ) async throws -> [WarikanGroupData] {
        var dataList: [WarikanGroupData] = []
        for warikanGroup in self {
            let data = try await WarikanGroupData.create(
                from: warikanGroup,
                memberRepository: memberRepository,
                tatekaeRepository: tatekaeRepository
            )
            dataList.append(data)
        }
        return dataList
    }
}
