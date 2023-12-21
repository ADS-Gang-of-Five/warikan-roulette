//
//  WarikanGroupArchiveController.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/08
//  
//

import Foundation

/// 割り勘グループのアーカイブ制御についてのユースケースを提供する。
struct WarikanGroupArchiveController {
    private var warikanGroupRepository: WarikanGroupRepositoryProtocol
    private var archivedWarikanGroupRepository: ArchivedWarikanGroupRepositoryProtocol
    
    init(warikanGroupRepository: WarikanGroupRepositoryProtocol, archivedWarikanGroupRepository: ArchivedWarikanGroupRepositoryProtocol) {
        self.warikanGroupRepository = warikanGroupRepository
        self.archivedWarikanGroupRepository = archivedWarikanGroupRepository
    }
    
    /// 指定したIDの割り勘グループを、清算済グループとしてアーカイブする。
    ///
    /// - parameter id: アーカイブする割り勘グループ。
    /// - parameter seisanList: その割り勘グループで計算された清算リスト。
    /// - parameter unluckyMember: 選ばれたアンラッキーメンバー。アンラッキーメンバーがいない場合は`nil`を渡す。
    /// - returns: アーカイブ後の清算済グループの識別子。
    func archive(id: EntityID<WarikanGroup>, seisanList: [SeisanData], unluckyMember: EntityID<Member>?) async throws -> EntityID<ArchivedWarikanGroup> {
        return try await warikanGroupRepository.transaction {
            // 割り勘グループのリポジトリから削除
            guard let target = try await warikanGroupRepository.find(id: id) else {
                throw ValidationError.notFoundID(id)
            }
            try await warikanGroupRepository.remove(id: target.id)
            
            // 清算済グループのリポジトリに保存
            return try await archivedWarikanGroupRepository.transaction {
                let archivedWarikanGroupID = try await archivedWarikanGroupRepository.nextID()
                let archivedWarikanGroup = ArchivedWarikanGroup(
                    id: archivedWarikanGroupID,
                    name: target.name,
                    members: target.members,
                    tatekaeList: target.tatekaeList,
                    unluckyMember: unluckyMember,
                    seisanList: seisanList.mapToEntity()
                )
                try await archivedWarikanGroupRepository.save(archivedWarikanGroup)
                return archivedWarikanGroupID
            }
        }
    }
}
