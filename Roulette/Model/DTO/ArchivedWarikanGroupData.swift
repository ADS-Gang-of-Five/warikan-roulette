//
//  ArchivedWarikanGroupData.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/21
//  
//

import Foundation

/// アーカイブされた割り勘グループのデータ。
struct ArchivedWarikanGroupData: Identifiable {
    var id: EntityID<ArchivedWarikanGroup>
    let groupName: String
    let members: [MemberData]
    let tatekaeList: [TatekaeData]
    let unluckyMember: MemberData?
    let seisanList: [SeisanData]

    private init(
        id: EntityID<ArchivedWarikanGroup>,
        name: String,
        members: [MemberData],
        tatekaeList: [TatekaeData],
        unluckyMember: MemberData?,
        seisanList: [SeisanData]
    ) {
        self.id = id
        self.groupName = name
        self.members = members
        self.tatekaeList = tatekaeList
        self.unluckyMember = unluckyMember
        self.seisanList = seisanList
    }

    /// 永続化用のデータ型から変換する。
    static func create(
        from group: ArchivedWarikanGroup,
        memberRepository: MemberRepositoryProtocol,
        tatekaeRepository: TatekaeRepositoryProtocol
    ) async throws -> Self {
        let members = try await memberRepository.find(ids: group.members)
        let tatekaeList = try await tatekaeRepository.find(ids: group.tatekaeList)
        let unluckyMember: MemberData? = if let memberID = group.unluckyMember {
            .create(from: try await memberRepository.find(id: memberID))
        } else {
            nil
        }
        return .init(
            id: group.id,
            name: group.name,
            members: members.mapToData(),
            tatekaeList: try await tatekaeList.mapToData(withMemberRepository: memberRepository),
            unluckyMember: unluckyMember,
            seisanList: try await group.seisanList.mapToData(withMemberRepository: memberRepository)
        )
    }
}

// MARK: - [ArchivedWarikanGroup]

extension [ArchivedWarikanGroup] {
    func mapToData(
        withMemberRepository memberRepository: MemberRepositoryProtocol,
        withTatekaeRepository tatekaeRepository: TatekaeRepositoryProtocol
    ) async throws -> [ArchivedWarikanGroupData] {
        var dataList: [ArchivedWarikanGroupData] = []
        for archivedWarikanGroup in self {
            let data = try await ArchivedWarikanGroupData.create(
                from: archivedWarikanGroup,
                memberRepository: memberRepository,
                tatekaeRepository: tatekaeRepository
            )
            dataList.append(data)
        }
        return dataList
    }
}
