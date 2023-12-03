//
//  MemberUseCase.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/03
//  
//

import Foundation

struct MemberUsecase {
    private var memberRepository: MemberRepositoryProtocol
    
    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }
    
    /// 指定したIDのメンバーを返す。
    func get(id: EntityID<Member>) async throws -> Member? {
        return try await memberRepository.find(id: id)
    }
}
