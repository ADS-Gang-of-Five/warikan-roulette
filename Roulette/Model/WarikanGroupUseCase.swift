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
    
    init(
        warikanGroupRepository: WarikanGroupRepositoryProtocol,
        memberRepository: MemberRepositoryProtocol
    ) {
        self.warikanGroupRepository = warikanGroupRepository
        self.memberRepository = memberRepository
    }
    
    /// 登録されている割り勘グループの配列の全体を返す。
    func findAll() async throws -> [WarikanGroup] {
        return try await warikanGroupRepository.findAll()
    }
    
    /// 割り勘グループを新規作成する。
    ///
    /// 新規作成した割り勘グループは `findAll()` で得られる割り勘グループ配列の末尾に追加される。
    func create(name: String, memberNames: [String]) async throws {
        // メンバー作成
        let members = memberNames.map { Member(name: $0) }
        try await memberRepository.transaction {
            for member in members {
                try await memberRepository.save(member)
            }
        }
        
        // 割り勘グループ作成
        let memberIDs = members.map { $0.id }
        try await warikanGroupRepository.transaction {
            try await warikanGroupRepository.save(WarikanGroup(name: name, members: memberIDs))
        }
    }
    
    /// 指定したインデックスの割り勘グループを削除する。
    ///
    /// 割り勘グループの削除に伴って、その割り勘グループに所属するメンバーの情報も削除される。
    func remove(at indices: [Int]) async throws {
        try await warikanGroupRepository.transaction {
            // 削除対象の割り勘グループを取得
            let warikanGroups: [WarikanGroup]
            do {
                warikanGroups = try await warikanGroupRepository.find(indices: indices)
            } catch {
                print("ERROR: 削除対象の割り勘グループ (indices=\(indices)) の取得に失敗: \(error)")
                throw error
            }
            
            // 割り勘グループを削除
            try await memberRepository.transaction {
                for warikanGroup in warikanGroups {
                    try await remove(warikanGroup: warikanGroup)
                }
            }
        }
    }
    
    /// 与えられた割り勘グループと所属メンバーを削除する。
    ///
    /// - Note: `warikanGroupRepository` および `memberRepository` のトランザクション内で呼び出すこと。
    private func remove(warikanGroup: WarikanGroup) async throws {
        do {
            // 割り勘グループを削除
            try await warikanGroupRepository.remove(id: warikanGroup.id)
            
            // 所属メンバーを削除
            for memberID in warikanGroup.members {
                try await memberRepository.remove(id: memberID)
            }
        } catch {
            print("ERROR: 割り勘グループ (id:\(warikanGroup.id)) の削除に失敗: \(error)")
            throw error
        }
    }
}
