//
//  WarikanGroupUseCase.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/11/27
//  
//

import Foundation

// TODO: warikanGroupRepository.find の強制アンラップを外す。
struct WarikanGroupUsecase {
    private var warikanGroupRepository: WarikanGroupRepositoryProtocol
    private var memberRepository: MemberRepositoryProtocol
    
    init(warikanGroupRepository: WarikanGroupRepositoryProtocol, memberRepository: MemberRepositoryProtocol) {
        self.warikanGroupRepository = warikanGroupRepository
        self.memberRepository = memberRepository
    }
    
    /// 登録されている割り勘グループの配列の全体を返す。
    func getAll() async throws -> [WarikanGroup] {
        return try await warikanGroupRepository.findAll()
    }
    
    /// 割り勘グループを新規作成する。
    ///
    /// 新規作成した割り勘グループは `findAll()` で得られる割り勘グループ配列の末尾に追加される。
    func create(name: String, memberNames: [String]) async throws {
        try await memberRepository.transaction {
            let memberIDs = try await memberRepository.nextIDs(count: memberNames.count)
            for (id, name) in zip(memberIDs, memberNames) {
                try await memberRepository.save(Member(id: id, name: name))
            }
            
            try await warikanGroupRepository.transaction {
                let warikanGroupID = try await warikanGroupRepository.nextID()
                try await warikanGroupRepository.save(WarikanGroup(id: warikanGroupID, name: name, members: memberIDs, tatekaeList: []))
            }
        }
    }
    
    /// 指定したインデックスの割り勘グループを削除する。
    func remove(_ ids: [EntityID<WarikanGroup>]) async throws {
        var warikanGroups = [WarikanGroup]()
        for id in ids {
            let warikanGroup = try await warikanGroupRepository.find(id: id)!
            warikanGroups.append(warikanGroup)
        }
        
        for warikanGroup in warikanGroups {
            try await warikanGroupRepository.transaction {
                try await warikanGroupRepository.remove(id: warikanGroup.id)
            }
        }
    }
    
    /// 新規メンバーを追加する。
    ///
    /// 作成したメンバーは配列`WarikanGroup.members`の末尾に追加される。
    func createMember(warikanGroup warikanGroupID: EntityID<WarikanGroup>, name: String) async throws {
        try await memberRepository.transaction {
            let memberID = try await memberRepository.nextID()
            try await memberRepository.save(Member(id: memberID, name: name))
            
            try await warikanGroupRepository.transaction {
                var warikanGroup = try await warikanGroupRepository.find(id: warikanGroupID)!
                warikanGroup.members.append(memberID)
                try await warikanGroupRepository.save(warikanGroup)
            }
        }
    }
    
    /// メンバーを削除する。
    func removeMember(warikanGroup warikanGroupID: EntityID<WarikanGroup>, member memberID: EntityID<Member>) async throws {
        try await warikanGroupRepository.transaction {
            var warikanGroup = try await warikanGroupRepository.find(id: warikanGroupID)!
            warikanGroup.members.removeAll { $0 == memberID }
            try await warikanGroupRepository.save(warikanGroup)
            
            try await memberRepository.transaction {
                try await memberRepository.remove(id: memberID)
            }
        }
    }
    
    /// 立て替えを追加する。
    func appendTatekae(warikanGroupID: EntityID<WarikanGroup>, tatekaeName: String, payer: Member, recipants: [Member], money: Int) async throws {
        let newTatekae = Tatekae(name: tatekaeName, payer: payer, recipients: recipants, money: money)
        try await warikanGroupRepository.transaction {
            var warikanGroup = try await warikanGroupRepository.find(id: warikanGroupID)!
            warikanGroup.tatekaeList.append(newTatekae)
            try await warikanGroupRepository.save(warikanGroup)
        }
    }
    
    /// 立て替えを一件削除する。
    func removeTatekae(warikanGroupID: EntityID<WarikanGroup>, tatekaeID: EntityID<Tatekae>) async throws {
        try await warikanGroupRepository.transaction {
            var warikanGroup = try await warikanGroupRepository.find(id: warikanGroupID)!
            warikanGroup.tatekaeList.removeAll { $0.id == tatekaeID }
            try await warikanGroupRepository.save(warikanGroup)
        }
    }
}
