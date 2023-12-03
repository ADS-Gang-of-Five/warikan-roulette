//
//  TatekaeUseCase.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/03
//  
//

import Foundation

struct TatekaeUsecase {
    private var tatekaeRepository: TatekaeRepositoryProtocol
    
    init(tatekaeRepository: TatekaeRepositoryProtocol) {
        self.tatekaeRepository = tatekaeRepository
    }
    
    /// 指定したIDのメンバーを返す。
    func get(id: EntityID<Tatekae>) async throws -> Tatekae? {
        return try await tatekaeRepository.find(id: id)
    }
}
