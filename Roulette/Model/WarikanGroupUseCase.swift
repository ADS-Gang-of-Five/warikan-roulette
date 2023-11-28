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
        // 削除対象の割り勘グループを取得
        let warikanGroups: [WarikanGroup]
        do {
            warikanGroups = try await warikanGroupRepository.find(indices: indices)
        } catch {
            // TODO: 具体的にどのインデックスで失敗したのか分かりにくい。
            print("ERROR: 削除対象の割り勘グループ (indices=\(indices)) の取得に失敗: \(error)")
            throw error
        }
            
        // 割り勘グループを削除
        for warikanGroup in warikanGroups {
            do {
                try await warikanGroupRepository.transaction {
                    try await warikanGroupRepository.remove(id: warikanGroup.id)
                }
            } catch {
                print("ERROR: 割り勘グループ (id:\(warikanGroup.id)) の削除に失敗: \(error)")
                throw error
            }
        }
    }
}
