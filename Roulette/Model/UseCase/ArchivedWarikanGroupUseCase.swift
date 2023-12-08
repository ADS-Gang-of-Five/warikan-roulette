//
//  ArchivedWarikanGroupUseCase.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/08
//  
//

import Foundation

struct ArchivedWarikanGroupUseCase {
    private var repository: ArchivedWarikanGroupRepositoryProtocol
    private var memberRepository: MemberRepositoryProtocol
    
    init(archivedWarikanGroupRepository: ArchivedWarikanGroupRepositoryProtocol, memberRepository: MemberRepositoryProtocol) {
        self.repository = archivedWarikanGroupRepository
        self.memberRepository = memberRepository
    }
    
    /// 登録されている割り勘グループの配列の全体を返す。
    func getAll() async throws -> [ArchivedWarikanGroup] {
        return try await repository.findAll()
    }
    
    /// 指定したIDの割り勘グループを削除する。
    func remove(ids: [EntityID<ArchivedWarikanGroup>]) async throws {
        try await repository.transaction {
            var targets = [ArchivedWarikanGroup]()
            for id in ids {
                guard let warikanGroup = try await repository.find(id: id) else {
                    throw ValidationError.notFoundID(id)
                }
                targets.append(warikanGroup)
            }
            
            for warikanGroup in targets {
                try await repository.remove(id: warikanGroup.id)
                try await memberRepository.transaction {
                    try await memberRepository.remove(ids: warikanGroup.members)
                }
            }
        }
    }
}
