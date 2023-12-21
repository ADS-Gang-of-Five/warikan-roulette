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
    private(set) var name: String
    private(set) var members: [EntityID<Member>]
    private(set) var tatekaeList: [EntityID<Tatekae>]
    private(set) var unluckyMember: EntityID<Member>?
    private(set) var seisanList: [SeisanData]

    private init(
        id: EntityID<ArchivedWarikanGroup>,
        name: String,
        members: [EntityID<Member>],
        tatekaeList: [EntityID<Tatekae>],
        unluckyMember: EntityID<Member>? = nil,
        seisanList: [SeisanData]
    ) {
        self.id = id
        self.name = name
        self.members = members
        self.tatekaeList = tatekaeList
        self.unluckyMember = unluckyMember
        self.seisanList = seisanList
    }

    /// 永続化用のデータ型から変換する。
    static func create(
        from archivedWarikanGroup: ArchivedWarikanGroup,
        memberRepository: MemberRepositoryProtocol
    ) async throws -> Self {
        return .init(
            id: archivedWarikanGroup.id,
            name: archivedWarikanGroup.name,
            members: archivedWarikanGroup.members,
            tatekaeList: archivedWarikanGroup.tatekaeList,
            seisanList: try await archivedWarikanGroup.seisanList.mapToData(withMemberRepository: memberRepository)
        )
    }

    /// 永続化のためのデータ型に変換する。
    /// - IMPORTANT: 原則ユースケース以外の場所で使用しないこと。
    func convertToSeisan() -> ArchivedWarikanGroup {
        ArchivedWarikanGroup(
            id: id,
            name: name,
            members: members,
            tatekaeList: tatekaeList,
            unluckyMember: unluckyMember,
            seisanList: seisanList.map { $0.convertToSeisan() }
        )
    }
}
