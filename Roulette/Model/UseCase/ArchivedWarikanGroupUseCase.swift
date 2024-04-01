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
    private var tatekaeRepository: TatekaeRepositoryProtocol
    
    init(
        archivedWarikanGroupRepository: ArchivedWarikanGroupRepositoryProtocol,
        memberRepository: MemberRepositoryProtocol,
        tatekaeRepository: TatekaeRepositoryProtocol
    ) {
        self.repository = archivedWarikanGroupRepository
        self.memberRepository = memberRepository
        self.tatekaeRepository = tatekaeRepository
    }
    
    /// 登録されている割り勘グループの配列の全体を返す。
    func getAll() async throws -> [ArchivedWarikanGroupData] {
        let archivedWarikanGroups = try await repository.findAll()
        return try await archivedWarikanGroups.mapToData(
            withMemberRepository: memberRepository,
            withTatekaeRepository: tatekaeRepository
        )
    }
    
    /// 指定したIDの割り勘グループのデータを返す。
    func get(id: EntityID<ArchivedWarikanGroup>) async throws -> ArchivedWarikanGroupData {
        guard let archivedWarikanGroup = try await repository.find(id: id) else {
            throw ValidationError.notFoundID(id)
        }
        return try await ArchivedWarikanGroupData.create(
            from: archivedWarikanGroup,
            memberRepository: memberRepository,
            tatekaeRepository: tatekaeRepository
        )
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
