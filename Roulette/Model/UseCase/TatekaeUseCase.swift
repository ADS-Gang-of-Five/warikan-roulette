//
//  TatekaeUseCase.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/03
//  
//

import Foundation

struct TatekaeUseCase {
    private var tatekaeRepository: TatekaeRepositoryProtocol
    private var memberRepository: MemberRepositoryProtocol
    
    init(
        tatekaeRepository: TatekaeRepositoryProtocol,
        memberRepository: MemberRepositoryProtocol
    ) {
        self.tatekaeRepository = tatekaeRepository
        self.memberRepository = memberRepository
    }
    
    /// 指定したIDの立て替えを返す。
    func get(id: EntityID<Tatekae>) async throws -> TatekaeData {
        let tatekae = try await tatekaeRepository.find(id: id)
        return try await .create(from: tatekae, memberRepository: memberRepository)
    }
    
    /// 指定した複数のIDの立て替えを返す。
    func get(ids: [EntityID<Tatekae>]) async throws -> [TatekaeData] {
        return try await tatekaeRepository.find(ids: ids)
            .mapToData(withMemberRepository: memberRepository)
    }
}
