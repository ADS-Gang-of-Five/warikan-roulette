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
    
    init(warikanGroupRepository: WarikanGroupRepositoryProtocol) {
        self.warikanGroupRepository = warikanGroupRepository
    }
    
    /// 登録されている割り勘グループの配列の全体を返す。
    func findAll() async throws -> [WarikanGroup] {
        return try await warikanGroupRepository.findAll()
    }
    
    /// 割り勘グループを新規作成する。
    ///
    /// 新規作成した割り勘グループは `findAll()` で得られる割り勘グループ配列の末尾に追加される。
    func create(name: String, memberNames: [String]) async throws {
        let members = memberNames.map { Member(name: $0) }
        try await warikanGroupRepository.transaction {
            try await warikanGroupRepository.save(WarikanGroup(name: name, members: members))
        }
    }
    
    /// 指定したインデックスの割り勘グループを削除する。
    func remove(at indices: [Int]) async throws {
        let warikanGroups = try await warikanGroupRepository.find(indices: indices)
        for warikanGroup in warikanGroups {
            try await warikanGroupRepository.transaction {
                try await warikanGroupRepository.remove(id: warikanGroup.id)
            }
        }
    }
    
    /// 新規メンバーを追加する。
    ///
    /// 作成したメンバーは配列`WarikanGroup.members`の末尾に追加される。
    func createMember(warikanGroupID: UUID, name: String) async throws {
        let newMember = Member(name: name)
        try await warikanGroupRepository.transaction {
            let warikanGroup = try await warikanGroupRepository.find(id: warikanGroupID)!
            try await warikanGroupRepository.save(
                // TODO: IDを使って生成しているので要修正
                WarikanGroup(id: warikanGroupID, name: warikanGroup.name, members: warikanGroup.members + [newMember])
            )
        }
    }
    
    /// メンバーを削除する。
    func removeMember(warikanGroupID: UUID, memberID: UUID) async throws {
        try await warikanGroupRepository.transaction {
            let warikanGroup = try await warikanGroupRepository.find(id: warikanGroupID)!
            try await warikanGroupRepository.save(
                // TODO: IDを使って生成しているので要修正
                WarikanGroup(id: warikanGroupID, name: warikanGroup.name, members: warikanGroup.members.filter { $0.id != memberID })
            )
        }
    }
}
