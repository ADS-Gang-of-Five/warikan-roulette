//
//  WarikanGroupUseCase.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/11/27
//  
//

import Foundation

struct WarikanGroupUsecase {
    private var warikanGroupRepository: WarikanGroupRepositoryProtocol
    private var memberRepository: MemberRepositoryProtocol
    private var tatekaeRepository: TatekaeRepositoryProtocol
    
    init(warikanGroupRepository: WarikanGroupRepositoryProtocol, memberRepository: MemberRepositoryProtocol, tatekaeRepository: TatekaeRepositoryProtocol) {
        self.warikanGroupRepository = warikanGroupRepository
        self.memberRepository = memberRepository
        self.tatekaeRepository = tatekaeRepository
    }
    
    /// 登録されている割り勘グループの配列の全体を返す。
    func getAll() async throws -> [WarikanGroup] {
        return try await warikanGroupRepository.findAll()
    }
    
    /// 割り勘グループを新規作成する。
    ///
    /// 新規作成した割り勘グループは `getAll()` で得られる割り勘グループ配列の末尾に追加される。
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
    
    /// 指定したIDの割り勘グループを削除する。
    func remove(ids: [EntityID<WarikanGroup>]) async throws {
        try await warikanGroupRepository.transaction {
            var warikanGroups = [WarikanGroup]()
            for id in ids {
                guard let warikanGroup = try await warikanGroupRepository.find(id: id) else {
                    throw ValidationError.notFoundID(id)
                }
                // FIXME: appendになってる？？
                warikanGroups.append(warikanGroup)
            }
            
            for warikanGroup in warikanGroups {
                try await warikanGroupRepository.remove(id: warikanGroup.id)
                try await memberRepository.transaction {
                    try await memberRepository.remove(ids: warikanGroup.members)
                }
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
                guard var warikanGroup = try await warikanGroupRepository.find(id: warikanGroupID) else {
                    throw ValidationError.notFoundID(warikanGroupID)
                }
                warikanGroup.members.append(memberID)
                try await warikanGroupRepository.save(warikanGroup)
            }
        }
    }
    
    /// メンバーを削除する。
    func removeMember(warikanGroup warikanGroupID: EntityID<WarikanGroup>, member memberID: EntityID<Member>) async throws {
        try await warikanGroupRepository.transaction {
            guard var warikanGroup = try await warikanGroupRepository.find(id: warikanGroupID) else {
                throw ValidationError.notFoundID(warikanGroupID)
            }
            warikanGroup.members.removeAll { $0 == memberID }
            try await warikanGroupRepository.save(warikanGroup)
            
            try await memberRepository.transaction {
                try await memberRepository.remove(id: memberID)
            }
        }
    }
    
    /// 立て替えを追加する。
    func appendTatekae(warikanGroup warikanGroupID: EntityID<WarikanGroup>, tatekaeName: String, payer: EntityID<Member>, recipants: [EntityID<Member>], money: Int) async throws {
        try await tatekaeRepository.transaction {
            let tatekaeID = try await tatekaeRepository.nextID()
            try await tatekaeRepository.save(Tatekae(id: tatekaeID, name: tatekaeName, payer: payer, recipients: recipants, money: money))
            
            try await warikanGroupRepository.transaction {
                guard var warikanGroup = try await warikanGroupRepository.find(id: warikanGroupID) else {
                    throw ValidationError.notFoundID(warikanGroupID)
                }
                warikanGroup.tatekaeList.append(tatekaeID)
                try await warikanGroupRepository.save(warikanGroup)
            }
        }
    }
    
    /// 立て替えを一件削除する。
    func removeTatekae(warikanGroup warikanGroupID: EntityID<WarikanGroup>, tatekae tatekaeID: EntityID<Tatekae>) async throws {
        try await warikanGroupRepository.transaction {
            guard var warikanGroup = try await warikanGroupRepository.find(id: warikanGroupID) else {
                throw ValidationError.notFoundID(warikanGroupID)
            }
            warikanGroup.tatekaeList.removeAll { $0 == tatekaeID }
            try await warikanGroupRepository.save(warikanGroup)
            
            try await tatekaeRepository.transaction {
                try await tatekaeRepository.remove(id: tatekaeID)
            }
        }
    }
}

